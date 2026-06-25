import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import '../core/constants/app_constants.dart';
import '../core/database/app_database.dart';

import '../features/library/data/sources/android_media_store_source.dart';
import '../features/library/data/sources/ios_media_source.dart';
import '../features/library/data/sources/media_platform_source.dart';
import '../features/library/domain/entities/scan_state.dart';
import 'scan_isolate_worker.dart';
import 'thumbnail_queue.dart';

// ── WorkManager task name ────────────────────────────────────────────────────

const _kBackgroundScanTask = 'mx_video_background_scan';

/// Register this as the top-level WorkManager callback dispatcher in main().
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == _kBackgroundScanTask) {
      // Open a fresh DB connection in the background isolate.
      final db = AppDatabase();
      try {
        final service = MediaScannerService(db: db);
        await service.scan(
          rootPaths: inputData?['rootPaths'] != null
              ? List<String>.from(inputData!['rootPaths'] as List)
              : null,
          emitProgress: false, // no UI in background
        ).last; // wait for completion
      } finally {
        await db.close();
      }
    }
    return Future.value(true);
  });
}

// ── MediaScannerService ──────────────────────────────────────────────────────

/// Orchestrates the full media scan pipeline:
///
///  Phase 1 — [ScanPhase.queryingPlatform]
///    Calls the native plugin (MediaStore on Android, Documents+Photos on iOS).
///    This is the only I/O that must happen on the main thread.
///
///  Phase 2 — [ScanPhase.processingFiles]
///    Offloads deduplication + folder grouping to a Dart isolate via [compute].
///    No DB, no platform channels inside the isolate.
///
///  Phase 3 — [ScanPhase.savingToDatabase]
///    Batch-upserts files and folders into Drift in chunks of 200.
///    Chunking keeps the main thread responsive during large scans.
///
///  Phase 4 — [ScanPhase.generatingThumbnails]
///    Hands the first [_eagerThumbnailCount] video paths to [ThumbnailQueue]
///    for eager pre-generation. The rest are generated lazily when cells appear.
///
class MediaScannerService {
  MediaScannerService({required AppDatabase this._db});

  final AppDatabase _db;

  static const int _dbChunkSize = 500;
  static const int _eagerThumbnailCount = 200;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Returns a [Stream<ScanState>] that emits progress updates.
  /// The stream closes after [ScanPhase.complete] or [ScanPhase.error].
  ///
  /// [rootPaths] is ignored on Android (MediaStore covers all volumes).
  /// On iOS, the Documents directory is always scanned; [rootPaths] is unused.
  Stream<ScanState> scan({
    List<String>? rootPaths,
    bool emitProgress = true,
  }) async* {
    final controller = StreamController<ScanState>();
    final startedAt = DateTime.now();

    void emit(ScanState s) {
      if (emitProgress && !controller.isClosed) controller.add(s);
    }

    try {
      // ── Phase 1: Query platform ───────────────────────────────────────────
      emit(ScanState(phase: ScanPhase.queryingPlatform, startedAt: startedAt));

      final source = _platformSource();
      final rawVideos = await source.queryVideos();
      final rawAudios = await source.queryAudios();
      final allRaw = [...rawVideos, ...rawAudios];

      emit(ScanState(
        phase: ScanPhase.processingFiles,
        total: allRaw.length,
        startedAt: startedAt,
      ));

      if (allRaw.isEmpty) {
        yield ScanState(
          phase: ScanPhase.complete,
          startedAt: startedAt,
          completedAt: DateTime.now(),
        );
        return;
      }

      // ── Phase 2: Process in isolate ───────────────────────────────────────
      final input = ScanIsolateInput(
        rawItems: allRaw.map((i) => i.toMap()).toList(),
      );

      final result = await compute(processMediaItems, input);

      // ── Phase 3: Save to DB in chunks ─────────────────────────────────────
      emit(ScanState(
        phase: ScanPhase.savingToDatabase,
        total: result.files.length,
        foldersFound: result.folders.length,
        startedAt: startedAt,
      ));

      int saved = 0;

      // Upsert folders first so FK constraints are satisfied when files land.
      final folderIdMap = await _upsertFolders(result.folders);

      for (var i = 0; i < result.files.length; i += _dbChunkSize) {
        final chunk = result.files.sublist(
          i,
          (i + _dbChunkSize).clamp(0, result.files.length),
        );
        await _upsertFiles(chunk, folderIdMap);
        saved += chunk.length;
        emit(ScanState(
          phase: ScanPhase.savingToDatabase,
          scanned: saved,
          total: result.files.length,
          foldersFound: result.folders.length,
          startedAt: startedAt,
          currentFile: chunk.last.name,
        ));
      }

      // ── Phase 4: Eager thumbnails ─────────────────────────────────────────
      // Strategy: Pick one video per folder first (sorted by video count
      // descending) to get folder cover thumbnails ASAP, then fill remaining
      // slots with extra videos from the largest folders.
      final videoFiles = result.files
          .where((f) => AppConstants.videoExtensions.contains(f.extension))
          .toList();

      // Sort folders by video count descending — biggest folders first.
      final sortedFolders = result.folders.toList()
        ..sort((a, b) => b.videoCount.compareTo(a.videoCount));

      // Pick one video per folder for covers.
      final coverPaths = <String>[];
      final coverFolderPaths = <String, String>{}; // videoPath → folderPath
      final usedPaths = <String>{};

      for (final folder in sortedFolders) {
        final firstVideo = videoFiles.firstWhere(
          (f) => f.folderPath == folder.absolutePath && !usedPaths.contains(f.absolutePath),
          orElse: () => videoFiles.first, // fallback, won't match below
        );
        if (firstVideo.folderPath == folder.absolutePath) {
          coverPaths.add(firstVideo.absolutePath);
          coverFolderPaths[firstVideo.absolutePath] = folder.absolutePath;
          usedPaths.add(firstVideo.absolutePath);
        }
      }

      // Fill remaining slots with more videos from large folders.
      final remainingCount = _eagerThumbnailCount - coverPaths.length;
      final extraPaths = videoFiles
          .where((f) => !usedPaths.contains(f.absolutePath))
          .take(remainingCount > 0 ? remainingCount : 0)
          .map((f) => f.absolutePath)
          .toList();

      final allEagerPaths = [...coverPaths, ...extraPaths];

      emit(ScanState(
        phase: ScanPhase.generatingThumbnails,
        scanned: saved,
        total: allEagerPaths.length,
        foldersFound: result.folders.length,
        startedAt: startedAt,
      ));

      // Generate thumbnails concurrently. As each completes, assign folder
      // cover immediately if this was a cover path.
      int thumbsDone = 0;
      final folderCoverAssigned = <String>{};

      final thumbFutures = allEagerPaths.map((path) async {
        final thumbPath = await ThumbnailQueue.instance.request(path);
        if (thumbPath != null) {
          await _updateThumbnailPath(path, thumbPath);

          // Assign folder thumbnail immediately when cover thumbnail is ready.
          final folderPath = coverFolderPaths[path];
          if (folderPath != null && !folderCoverAssigned.contains(folderPath)) {
            folderCoverAssigned.add(folderPath);
            final folderId = folderIdMap[folderPath];
            if (folderId != null) {
              await (_db.mediaDao.update(_db.mediaDao.mediaFolders)
                    ..where((t) => t.id.equals(folderId)))
                  .write(MediaFoldersCompanion(thumbnailPath: Value(thumbPath)));
            }
          }
        }
        thumbsDone++;
        emit(ScanState(
          phase: ScanPhase.generatingThumbnails,
          scanned: saved,
          total: allEagerPaths.length,
          thumbnailsGenerated: thumbsDone,
          foldersFound: result.folders.length,
          startedAt: startedAt,
        ));
      }).toList();
      await Future.wait(thumbFutures);

      // Assign any remaining folder thumbnails that weren't covered above.
      await _assignFolderThumbnails(folderIdMap);

      // ── Complete ──────────────────────────────────────────────────────────
      final finalState = ScanState(
        phase: ScanPhase.complete,
        scanned: saved,
        total: saved,
        foldersFound: result.folders.length,
        thumbnailsGenerated: thumbsDone,
        startedAt: startedAt,
        completedAt: DateTime.now(),
      );

      emit(finalState);
      yield* controller.stream;
      yield finalState;
    } catch (e, st) {
      debugPrint('MediaScannerService error: $e\n$st');
      final errorState = ScanState(
        phase: ScanPhase.error,
        errorMessage: e.toString(),
        startedAt: startedAt,
        completedAt: DateTime.now(),
      );
      emit(errorState);
      yield* controller.stream;
      yield errorState;
    } finally {
      await controller.close();
    }
  }

  // ── WorkManager background registration ────────────────────────────────────

  /// Call once at app startup. Schedules a daily background rescan.
  static Future<void> registerBackgroundScan({
    List<String>? rootPaths,
  }) async {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      _kBackgroundScanTask,
      _kBackgroundScanTask,
      frequency: const Duration(hours: 24),
      constraints: Constraints(networkType: NetworkType.notRequired),
      inputData: rootPaths != null ? {'rootPaths': rootPaths} : null,
    );
  }

  static Future<void> cancelBackgroundScan() =>
      Workmanager().cancelByUniqueName(_kBackgroundScanTask);

  // ── DB helpers ─────────────────────────────────────────────────────────────

  Future<void> _upsertFiles(
    List<ProcessedMediaFile> files,
    Map<String, int> folderIdMap,
  ) async {
    final companions = files.map((f) {
      return MediaFilesCompanion.insert(
        absolutePath: f.absolutePath,
        name: f.name,
        extension: f.extension,
        sizeBytes: f.sizeBytes,
        scannedAt: f.scannedAtMs,
        durationMs: Value(f.durationMs),
        width: Value(f.width),
        height: Value(f.height),
        folderId: Value(folderIdMap[f.folderPath]),
      );
    }).toList();

    await _db.mediaDao.upsertFiles(companions);
  }

  /// Upserts all folders in a single batch and returns a map of folderPath → DB id.
  Future<Map<String, int>> _upsertFolders(
    List<ProcessedMediaFolder> folders,
  ) async {
    // Batch upsert all folders at once instead of one-by-one.
    final companions = folders
        .map((f) => MediaFoldersCompanion.insert(
              absolutePath: f.absolutePath,
              name: f.name,
              videoCount: Value(f.videoCount),
              audioCount: Value(f.audioCount),
            ))
        .toList();
    await _db.mediaDao.upsertFolders(companions);

    // Resolve IDs in a single query.
    final paths = folders.map((f) => f.absolutePath).toList();
    return _db.mediaDao.getFolderIdsByPaths(paths);
  }

  Future<void> _updateThumbnailPath(String videoPath, String thumbPath) async {
    final file = await _db.mediaDao.findByPath(videoPath);
    if (file == null) return;
    await (_db.mediaDao.update(_db.mediaDao.mediaFiles)
          ..where((t) => t.id.equals(file.id)))
        .write(MediaFilesCompanion(thumbnailPath: Value(thumbPath)));
  }

  /// Sets each folder's thumbnail to the first video file's thumbnail.
  /// If no file in the folder has a thumbnail yet, generates one on the spot.
  /// Processes all folders concurrently for speed.
  Future<void> _assignFolderThumbnails(Map<String, int> folderIdMap) async {
    await Future.wait(folderIdMap.entries.map((entry) async {
      final folderId = entry.value;

      // Try to find a file that already has a thumbnail.
      var files = await (_db.mediaDao.select(_db.mediaDao.mediaFiles)
            ..where((t) => t.folderId.equals(folderId))
            ..where((t) => t.thumbnailPath.isNotNull())
            ..limit(1))
          .get();

      if (files.isNotEmpty) {
        await (_db.mediaDao.update(_db.mediaDao.mediaFolders)
              ..where((t) => t.id.equals(folderId)))
            .write(MediaFoldersCompanion(
                thumbnailPath: Value(files.first.thumbnailPath)));
        return;
      }

      // No file has a thumbnail yet — generate one from the first video.
      final videoFiles = await (_db.mediaDao.select(_db.mediaDao.mediaFiles)
            ..where((t) => t.folderId.equals(folderId))
            ..limit(1))
          .get();

      if (videoFiles.isNotEmpty) {
        final thumbPath =
            await ThumbnailQueue.instance.request(videoFiles.first.absolutePath);
        if (thumbPath != null) {
          await (_db.mediaDao.update(_db.mediaDao.mediaFiles)
                ..where((t) => t.id.equals(videoFiles.first.id)))
              .write(MediaFilesCompanion(thumbnailPath: Value(thumbPath)));
          await (_db.mediaDao.update(_db.mediaDao.mediaFolders)
                ..where((t) => t.id.equals(folderId)))
              .write(MediaFoldersCompanion(thumbnailPath: Value(thumbPath)));
        }
      }
    }));
  }

  // ── Platform source factory ────────────────────────────────────────────────

  static MediaPlatformSource _platformSource() {
    if (Platform.isAndroid) return AndroidMediaStoreSource();
    if (Platform.isIOS) return IosMediaSource();
    throw UnsupportedError('Media scanning is not supported on this platform.');
  }

  // ── Thumbnail cache path ───────────────────────────────────────────────────

  static Future<String> thumbnailCacheDir() async {
    final base = await getApplicationCacheDirectory();
    return p.join(base.path, AppConstants.thumbnailCacheDirName);
  }
}
