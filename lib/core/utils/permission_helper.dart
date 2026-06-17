import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// Centralised permission requests for the app.
/// Always call [requestStoragePermission] before scanning or browsing.
class PermissionHelper {
  PermissionHelper._();

  /// Requests storage read access.
  /// Handles Android 13+ granular media permissions and older STORAGE permission.
  static Future<bool> requestStoragePermission() async {
    if (Platform.isIOS) {
      // iOS accesses files through the document picker — no explicit permission needed.
      return true;
    }

    // Android 13+ uses granular permissions.
    if (await _isAndroid13OrAbove()) {
      final video = await Permission.videos.request();
      final audio = await Permission.audio.request();
      return video.isGranted && audio.isGranted;
    }

    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Requests MANAGE_EXTERNAL_STORAGE for full storage browsing on Android 11+.
  static Future<bool> requestManageStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }

  /// Requests local network access (iOS only).
  static Future<bool> requestLocalNetworkPermission() async {
    if (!Platform.isIOS) return true;
    final status = await Permission.nearbyWifiDevices.request();
    return status.isGranted;
  }

  /// Requests notification permission (Android 13+ / iOS).
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> _isAndroid13OrAbove() async {
    // SDK 33 = Android 13.
    // TODO: read Build.VERSION.SDK_INT via platform channel if needed.
    return true;
  }

  static Future<void> openSettings() => openAppSettings();
}
