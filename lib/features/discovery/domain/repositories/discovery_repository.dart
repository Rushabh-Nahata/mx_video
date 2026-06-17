import '../../../transfer/domain/entities/peer_device.dart';

/// Contract for discovering MX Video devices on the local network.
abstract interface class DiscoveryRepository {
  /// Returns a continuous stream of discovered peer devices.
  /// The stream emits an updated list whenever devices appear or disappear.
  Stream<List<PeerDevice>> discoverDevices();

  /// Restart the underlying discovery session.
  /// Clears stale peers and begins a fresh scan.
  Future<void> restartDiscovery();

  /// Release all discovery resources.
  void dispose();
}
