import 'package:freezed_annotation/freezed_annotation.dart';

part 'peer_device.freezed.dart';
part 'peer_device.g.dart';

enum PeerPlatform { android, ios, windows, macos, linux, unknown }

/// How this peer was discovered.
enum ConnectionMethod {
  /// Both devices on the same WiFi — discovered via mDNS.
  wifi,

  /// Discovered via Bluetooth Low Energy advertising.
  bluetooth,

  /// Connected by scanning a QR code.
  qrCode,

  /// Android WiFi Direct (P2P group).
  wifiDirect,

  /// One device created a hotspot, other joined.
  hotspot,
}

@freezed
abstract class PeerDevice with _$PeerDevice {
  const factory PeerDevice({
    required String id,
    required String name,
    required String ipAddress,
    required int port,
    @Default(PeerPlatform.unknown) PeerPlatform platform,
    @Default(ConnectionMethod.wifi) ConnectionMethod connectionMethod,
    /// Session token for authenticated transfers (set after pairing).
    String? sessionToken,
  }) = _PeerDevice;

  factory PeerDevice.fromJson(Map<String, dynamic> json) =>
      _$PeerDeviceFromJson(json);
}
