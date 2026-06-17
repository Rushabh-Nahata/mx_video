import 'package:drift/drift.dart' hide Column;

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/media_dao.dart';
import '../../../../core/database/tables/media_table.dart';
import '../../../../services/media_scanner_service.dart';
import '../../domain/entities/media_file.dart';
import '../../domain/entities/media_folder.dart';
import '../../domain/entities/scan_state.dart';
import '../../domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl({
    required MediaDao dao,
    required AppDatabase db,
  })  : _dao = dao,
        _db = db;

  final MediaDao _dao;
  final AppDatabase _db;

  // ── Reactive queries ───────────────────────────────────────────────────────

  @override
  Stream<List<MediaFolderEntity>> watchFolders() =>
      _dao.watchAllFolders().map((rows) => rows.map(_mapFolder).toList());

  @override
  Stream<List<MediaFileEntity>> watchFilesInFolder(int folderId) =>
      _dao.watchByFolder(folderId).map((rows) => rows.map(_mapFile).toList());

  @override
  Stream<List<MediaFileEntity>> watchRecents({int limit = 50}) =>
      _dao.watchRecents(limit: limit).map((rows) => rows.map(_mapFile).toList());

  @override
  Stream<List<MediaFileEntity>> watchFavourites() =>
      _dao.watchFavourites().map((rows) => rows.map(_mapFile).toList());

  @override
  Stream<List<MediaFileEntity>> watchAllFiles() =>
      _dao.watchAllFiles().map((rows) => rows.map(_mapFile).toList());

  @override
  Stream<List<MediaFileEntity>> searchFiles(String query) =>
      _dao.searchFiles(query).map((rows) => rows.map(_mapFile).toList());

  // ── Scanning ───────────────────────────────────────────────────────────────

  @override
  Stream<ScanState> scan({List<String>? rootPaths}) {
    final service = MediaScannerService(db: _db);
    return service.scan(rootPaths: rootPaths);
  }

  // ── Playback tracking ──────────────────────────────────────────────────────

  @override
  Future<void> updatePlaybackPosition(int fileId, int positionMs) =>
      _dao.updatePlaybackPosition(fileId, positionMs);

  @override
  Future<void> toggleFavourite(int fileId, {required bool value}) =>
      _dao.toggleFavourite(fileId, value: value);

  // ── Mappers ────────────────────────────────────────────────────────────────

  MediaFileEntity _mapFile(MediaFile row) => MediaFileEntity(
        id: row.id,
        absolutePath: row.absolutePath,
        name: row.name,
        extension: row.extension,
        sizeBytes: row.sizeBytes,
        durationMs: row.durationMs,
        width: row.width,
        height: row.height,
        thumbnailPath: row.thumbnailPath,
        folderId: row.folderId,
        lastPlayedAt: row.lastPlayedAt,
        playPositionMs: row.playPositionMs,
        playCount: row.playCount,
        isFavourite: row.isFavourite,
        scannedAt: row.scannedAt,
      );

  MediaFolderEntity _mapFolder(MediaFolder row) => MediaFolderEntity(
        id: row.id,
        absolutePath: row.absolutePath,
        name: row.name,
        parentId: row.parentId,
        thumbnailPath: row.thumbnailPath,
        videoCount: row.videoCount,
        audioCount: row.audioCount,
        isWatched: row.isWatched,
      );
}
