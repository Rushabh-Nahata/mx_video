import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

import 'media_scanner_service.dart';

/// Priority-aware thumbnail generator.
///
/// Design:
///   - A fixed-size pool of [_maxConcurrent] concurrent generations prevents
///     overwhelming the device during a fresh scan.
///   - [request] adds to the end of the queue (background pre-generation).
///   - [requestPriority] inserts at the front (user just scrolled to this cell).
///   - Results are cached on disk; subsequent requests for the same path are
///     returned instantly from the cache without re-entering the queue.
///
/// Usage:
///   final path = await ThumbnailQueue.instance.request(videoPath);
class ThumbnailQueue {
  ThumbnailQueue._();
  static final ThumbnailQueue instance = ThumbnailQueue._();

  static const int _maxConcurrent = 6;
  static const int _thumbnailWidth = 256;
  static const int _thumbnailQuality = 50;
  static const int _maxCacheEntries = 1000;

  final _queue = Queue<_ThumbnailRequest>();
  final _inFlight = <String, Future<String?>>{}; // path → future
  /// LRU memory cache: most-recently-used entries stay at the end.
  final _cache = LinkedHashMap<String, String>();
  int _active = 0;
  String? _cacheDir;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Enqueues a thumbnail request. Returns the cached path if already done.
  Future<String?> request(String videoPath) => _enqueue(videoPath, priority: false);

  /// Bumps [videoPath] to the front — use when the user taps a cell.
  Future<String?> requestPriority(String videoPath) => _enqueue(videoPath, priority: true);

  /// Clears the pending queue. In-flight generations are not cancelled.
  void cancelAll() => _queue.clear();

  // ── Internal ───────────────────────────────────────────────────────────────

  Future<String?> _enqueue(String videoPath, {required bool priority}) async {
    // 1. Memory cache hit — promote to most-recently-used.
    if (_cache.containsKey(videoPath)) {
      final value = _cache.remove(videoPath)!;
      _cache[videoPath] = value;
      return value;
    }

    // 2. Disk cache hit
    final diskPath = await _diskCachePath(videoPath);
    if (await File(diskPath).exists()) {
      _cacheput(videoPath, diskPath);
      return diskPath;
    }

    // 3. Already in-flight
    if (_inFlight.containsKey(videoPath)) return _inFlight[videoPath];

    // 4. Enqueue
    final completer = Completer<String?>();
    final req = _ThumbnailRequest(path: videoPath, completer: completer);

    if (priority) {
      _queue.addFirst(req);
    } else {
      _queue.addLast(req);
    }

    _drain();
    return completer.future;
  }

  void _drain() {
    while (_active < _maxConcurrent && _queue.isNotEmpty) {
      final req = _queue.removeFirst();
      _active++;
      final future = _generate(req.path).then((result) {
        _inFlight.remove(req.path);
        _active--;
        req.completer.complete(result);
        _drain(); // keep the pool full
        return result;
      });
      _inFlight[req.path] = future;
    }
  }

  Future<String?> _generate(String videoPath) async {
    try {
      final dir = await _getCacheDir();
      final result = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: dir,
        imageFormat: ImageFormat.JPEG,
        maxWidth: _thumbnailWidth,
        quality: _thumbnailQuality,
      );
      if (result != null) _cacheput(videoPath, result);
      return result;
    } catch (_) {
      return null;
    }
  }

  /// LRU insert with eviction when cache exceeds max size.
  void _cacheput(String key, String value) {
    _cache[key] = value;
    while (_cache.length > _maxCacheEntries) {
      _cache.remove(_cache.keys.first);
    }
  }

  Future<String> _diskCachePath(String videoPath) async {
    final dir = await _getCacheDir();
    // Stable SHA-1 hash avoids collisions at scale (vs hashCode).
    final hash = sha1.convert(utf8.encode(videoPath)).toString().substring(0, 16);
    return p.join(dir, '$hash.jpg');
  }

  Future<String> _getCacheDir() async {
    if (_cacheDir != null) return _cacheDir!;
    _cacheDir = await MediaScannerService.thumbnailCacheDir();
    await Directory(_cacheDir!).create(recursive: true);
    return _cacheDir!;
  }

  /// Clears disk and memory caches. Cancels pending queue entries.
  Future<void> clearAll() async {
    _queue.clear();
    _cache.clear();
    final dir = await _getCacheDir();
    final d = Directory(dir);
    if (await d.exists()) {
      await for (final f in d.list()) {
        if (f is File) await f.delete();
      }
    }
  }
}

class _ThumbnailRequest {
  const _ThumbnailRequest({required this.path, required this.completer});
  final String path;
  final Completer<String?> completer;
}
