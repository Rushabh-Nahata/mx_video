import 'package:flutter/services.dart';

import 'media_platform_source.dart';

/// iOS implementation of [MediaPlatformSource].
///
/// Strategy:
///   1. Scans the app's Documents directory for user-imported files.
///      Users import videos via the iOS share sheet or Files app.
///   2. Queries PHPhotoLibrary for videos in the Camera Roll.
///      Returns PHAsset metadata + temporary export URL.
///
/// Channel: mx_video/media_scanner
/// Native counterpart: MediaLibraryPlugin.swift
class IosMediaSource implements MediaPlatformSource {
  static const _channel = MethodChannel('mx_video/media_scanner');

  @override
  Future<List<RawMediaItem>> queryVideos() async {
    final raw = await _channel.invokeListMethod<Map<dynamic, dynamic>>('queryVideos') ?? [];
    return raw
        .where((m) => m['path'] != null)
        .map((m) => RawMediaItem.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<List<RawMediaItem>> queryAudios() async {
    // iOS audio from Documents directory — returned by the same native method.
    final raw = await _channel.invokeListMethod<Map<dynamic, dynamic>>('queryAudios') ?? [];
    return raw
        .where((m) => m['path'] != null)
        .map((m) => RawMediaItem.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<List<String>> getStorageRoots() async {
    return await _channel.invokeListMethod<String>('getStorageRoots') ?? [];
  }
}
