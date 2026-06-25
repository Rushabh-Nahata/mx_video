import 'package:flutter/services.dart';

import 'media_platform_source.dart';

/// Android implementation of [MediaPlatformSource].
///
/// Queries the system [MediaStore] content provider via a MethodChannel.
/// MediaStore is O(1) — it does NOT walk the filesystem; the OS maintains
/// this index automatically as files change. This makes the initial scan
/// instant regardless of how many files are on the device.
///
/// Channel: mx_video/media_scanner
/// Native counterpart: MediaStorePlugin.kt
class AndroidMediaStoreSource implements MediaPlatformSource {
  static const _channel = MethodChannel('mx_video/media_scanner');

  @override
  Future<List<RawMediaItem>> queryVideos() async {
    final raw = await _channel.invokeListMethod<Map<dynamic, dynamic>>('queryVideos') ?? [];
    return raw.map((m) => RawMediaItem.fromMap(Map<String, dynamic>.from(m))).toList();
  }

  @override
  Future<List<RawMediaItem>> queryAudios() async {
    final raw = await _channel.invokeListMethod<Map<dynamic, dynamic>>('queryAudios') ?? [];
    return raw.map((m) => RawMediaItem.fromMap(Map<String, dynamic>.from(m))).toList();
  }

  @override
  Future<List<String>> getStorageRoots() async {
    final roots = await _channel.invokeListMethod<String>('getStorageRoots') ?? [];
    return roots;
  }
}
