import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/peer_device.dart';

/// Handles QR code-based peer pairing with secure handshake.
///
/// Protocol flow:
///   1. Device A shows QR containing: IP, port, name, platform, token, pairingCode
///   2. Device B scans the QR code and calls `POST /pair` with its own info
///   3. Both devices derive a shared verification code from the combined tokens
///   4. Both show the verification code — user confirms they match
///   5. Connection is established and ready for socket-based transfer
class QrPairingSource {
  /// Generate QR pairing data for this device.
  ///
  /// Returns a map with connection info + security tokens.
  Future<Map<String, dynamic>> generatePairingData({
    required int port,
    required String deviceName,
    required String platform,
    required String sessionToken,
  }) async {
    final ip = await NetworkInfo().getWifiIP();
    final pairingSecret = _generateSecret();

    return {
      'ip': ip ?? '',
      'port': port,
      'name': deviceName,
      'platform': platform,
      'token': sessionToken,
      'secret': pairingSecret,
      'v': 2, // protocol version (v2 = socket + encryption)
      'ts': DateTime.now().millisecondsSinceEpoch,
      'caps': ['socket', 'encryption', 'chunk_resume'],
    };
  }

  /// Encode pairing data as a QR-scannable string.
  ///
  /// Format: `mxvideo://pair?<base64url-encoded-json>`
  String encodePairingData(Map<String, dynamic> data) {
    return '${AppConstants.qrPrefix}${base64Url.encode(utf8.encode(jsonEncode(data)))}';
  }

  /// Decode a scanned QR string back into pairing data.
  /// Returns null if the QR code is not a valid MX Video pairing code.
  Map<String, dynamic>? decodePairingData(String qrData) {
    if (!qrData.startsWith(AppConstants.qrPrefix)) return null;

    try {
      final encoded = qrData.substring(AppConstants.qrPrefix.length);
      final json = utf8.decode(base64Url.decode(encoded));
      final data = jsonDecode(json) as Map<String, dynamic>;

      // Validate required fields.
      if (data['ip'] == null || data['port'] == null) return null;

      return data;
    } catch (_) {
      return null;
    }
  }

  /// Create a PeerDevice from decoded QR pairing data.
  PeerDevice? peerFromPairingData(Map<String, dynamic> data) {
    final ip = data['ip'] as String?;
    final port = data['port'] as int?;
    final name = data['name'] as String?;

    if (ip == null || ip.isEmpty || port == null) return null;

    return PeerDevice(
      id: 'qr_${ip}_$port',
      name: name ?? 'Scanned Device',
      ipAddress: ip,
      port: port,
      platform: _parsePlatform(data['platform'] as String? ?? ''),
      connectionMethod: ConnectionMethod.qrCode,
      sessionToken: data['token'] as String?,
    );
  }

  /// Derive a 4-digit verification code from both device tokens.
  ///
  /// Both devices compute this independently. If the codes match,
  /// the devices are talking to each other (not a MITM).
  String deriveVerificationCode(String localToken, String remoteToken) {
    // Sort tokens so both devices get the same input regardless of order.
    final tokens = [localToken, remoteToken]..sort();
    final combined = '${tokens[0]}:${tokens[1]}:mx_verify';
    final hash = sha256.convert(utf8.encode(combined)).toString();
    // Take first 4 hex chars → convert to a 4-digit numeric code.
    final numericHash = int.parse(hash.substring(0, 8), radix: 16);
    return (numericHash % 10000).toString().padLeft(4, '0');
  }

  /// Check if the QR data has expired (older than 5 minutes).
  bool isExpired(Map<String, dynamic> data) {
    final ts = data['ts'] as int?;
    if (ts == null) return false; // v1 codes don't have ts
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age > 5 * 60 * 1000; // 5 minutes
  }

  /// Check if the peer supports v2 protocol features.
  bool supportsSocketTransfer(Map<String, dynamic> data) {
    final version = data['v'] as int? ?? 1;
    return version >= 2;
  }

  /// Get the capabilities advertised in the QR data.
  List<String> getCapabilities(Map<String, dynamic> data) {
    final caps = data['caps'] as List?;
    return caps?.cast<String>() ?? [];
  }

  /// Get the pairing secret from QR data (used for encryption key derivation).
  String? getPairingSecret(Map<String, dynamic> data) {
    return data['secret'] as String?;
  }

  /// Detect the current platform string.
  String get currentPlatform {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  PeerPlatform _parsePlatform(String value) => switch (value) {
        'android' => PeerPlatform.android,
        'ios' => PeerPlatform.ios,
        'windows' => PeerPlatform.windows,
        'macos' => PeerPlatform.macos,
        'linux' => PeerPlatform.linux,
        _ => PeerPlatform.unknown,
      };

  /// Generate a random 16-character hex secret for this pairing session.
  String _generateSecret() {
    final rng = Random.secure();
    return List.generate(16, (_) => rng.nextInt(16).toRadixString(16)).join();
  }
}
