import 'package:path/path.dart' as p;

import '../features/library/data/sources/media_platform_source.dart';

// ── Input / Output models (must be isolate-safe: no platform channels, no DB) ──

/// All data the isolate needs — serialised as plain maps so it crosses the
/// isolate boundary without cloning Flutter objects.
class ScanIsolateInput {
  const ScanIsolateInput({required this.rawItems});
  final List<Map<String, dynamic>> rawItems;
}

/// A processed file ready for DB insertion.
class ProcessedMediaFile {
  const ProcessedMediaFile({
    required this.absolutePath,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    required this.folderPath,
    required this.scannedAtMs,
    this.durationMs,
    this.width,
    this.height,
    this.mimeType,
  });

  final String absolutePath;
  final String name;
  final String extension;
  final int sizeBytes;
  final String folderPath;
  final int scannedAtMs;
  final int? durationMs;
  final int? width;
  final int? height;
  final String? mimeType;
}

/// A processed folder ready for DB insertion.
class ProcessedMediaFolder {
  const ProcessedMediaFolder({
    required this.absolutePath,
    required this.name,
    required this.videoCount,
    required this.audioCount,
  });

  final String absolutePath;
  final String name;
  final int videoCount;
  final int audioCount;
}

/// Result returned by [processMediaItems].
class ScanIsolateResult {
  const ScanIsolateResult({
    required this.files,
    required this.folders,
    required this.duplicatesSkipped,
  });

  final List<ProcessedMediaFile> files;
  final List<ProcessedMediaFolder> folders;
  final int duplicatesSkipped;
}

// ── Top-level function — entry point for Dart's compute() ──────────────────

/// Processes a flat list of raw platform items:
///   1. Deserialises raw maps → [RawMediaItem]
///   2. Deduplicates by absolute path
///   3. Normalises extensions and mime types
///   4. Groups into folder buckets with counts
///
/// This function is intentionally pure (no I/O, no Flutter, no DB).
/// It runs inside [compute()] on a separate isolate.
ScanIsolateResult processMediaItems(ScanIsolateInput input) {
  final nowMs = DateTime.now().millisecondsSinceEpoch;
  final seen = <String>{};
  int dupes = 0;

  final files = <ProcessedMediaFile>[];
  // folderPath → {videoCount, audioCount}
  final folderMap = <String, _FolderAccumulator>{};

  for (final map in input.rawItems) {
    final item = RawMediaItem.fromMap(map);

    // Deduplication by canonical path
    final canon = _canonicalisePath(item.path);
    if (seen.contains(canon)) {
      dupes++;
      continue;
    }
    seen.add(canon);

    // Normalise extension
    final ext = item.extension.isNotEmpty
        ? item.extension
        : p.extension(item.name).replaceFirst('.', '').toLowerCase();

    files.add(ProcessedMediaFile(
      absolutePath: item.path,
      name: item.name,
      extension: ext,
      sizeBytes: item.sizeBytes,
      folderPath: item.folderPath,
      scannedAtMs: item.dateModifiedMs > 0 ? item.dateModifiedMs : nowMs,
      durationMs: item.durationMs,
      width: item.width == 0 ? null : item.width,
      height: item.height == 0 ? null : item.height,
      mimeType: item.mimeType,
    ));

    // Accumulate folder counts
    final acc = folderMap.putIfAbsent(
      item.folderPath,
      () => _FolderAccumulator(name: item.folderName),
    );
    if (item.isVideo) {
      acc.videoCount++;
    } else if (item.isAudio) {
      acc.audioCount++;
    }
  }

  final folders = folderMap.entries
      .map((e) => ProcessedMediaFolder(
            absolutePath: e.key,
            name: e.value.name,
            videoCount: e.value.videoCount,
            audioCount: e.value.audioCount,
          ))
      .toList();

  return ScanIsolateResult(
    files: files,
    folders: folders,
    duplicatesSkipped: dupes,
  );
}

// ── Helpers ─────────────────────────────────────────────────────────────────

String _canonicalisePath(String path) =>
    path.replaceAll(RegExp(r'/+'), '/').toLowerCase();

class _FolderAccumulator {
  _FolderAccumulator({required this.name});
  final String name;
  int videoCount = 0;
  int audioCount = 0;
}
