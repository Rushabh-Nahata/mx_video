import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

import 'media_scanner_service.dart';

/// Generates and caches video thumbnails on demand.
/// Thumbnails are stored as JPEGs under the app's cache directory.
class ThumbnailService {
  ThumbnailService._();
  static final ThumbnailService instance = ThumbnailService._();

  String? _cacheDir;

  Future<String> _getCacheDir() async {
    _cacheDir ??= await MediaScannerService.thumbnailCacheDir();
    final dir = Directory(_cacheDir!);
    if (!await dir.exists()) await dir.create(recursive: true);
    return _cacheDir!;
  }

  /// Returns the cached thumbnail path, generating it if not yet cached.
  Future<String?> getThumbnail(String videoPath) async {
    final cacheDir = await _getCacheDir();
    final hash = videoPath.hashCode.toRadixString(16);
    final cachedPath = p.join(cacheDir, '$hash.jpg');

    if (await File(cachedPath).exists()) return cachedPath;

    return VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: cacheDir,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 320,
      quality: 75,
    );
  }

  /// Deletes all cached thumbnails (e.g., on settings reset).
  Future<void> clearCache() async {
    final cacheDir = await _getCacheDir();
    final dir = Directory(cacheDir);
    if (await dir.exists()) {
      await for (final f in dir.list()) {
        if (f is File) await f.delete();
      }
    }
  }
}
