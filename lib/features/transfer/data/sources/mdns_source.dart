import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/peer_device.dart';

final _log = Logger(printer: SimplePrinter());

/// Discovers and advertises MX Video peers on the local network using mDNS.
///
/// Uses the Bonsoir package which wraps platform-native mDNS:
///   - Android: NsdManager
///   - iOS: NetService (Bonjour)
///   - Windows/macOS/Linux: native mDNS
class MdnsSource {
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  String? _localIp;

  /// Start advertising this device as an MX Video peer.
  Future<void> startAdvertising({
    required String deviceName,
    required int port,
    required String platform,
  }) async {
    await stopAdvertising();

    final service = BonsoirService(
      name: deviceName,
      type: AppConstants.mdnsServiceType,
      port: port,
      attributes: {
        'platform': platform,
        'version': AppConstants.appVersion,
      },
    );

    _broadcast = BonsoirBroadcast(service: service);
    await _broadcast!.ready;
    await _broadcast!.start();

    _log.i('mDNS: advertising "$deviceName" on port $port');
  }

  Future<void> stopAdvertising() async {
    await _broadcast?.stop();
    _broadcast = null;
  }

  /// Returns a stream of discovered peer lists.
  /// Continuously emits updated lists as peers appear or disappear.
  Stream<List<PeerDevice>> discoverPeers() async* {
    _localIp = await NetworkInfo().getWifiIP();

    final discovery = BonsoirDiscovery(type: AppConstants.mdnsServiceType);
    _discovery = discovery;
    await discovery.ready;
    await discovery.start();

    final peers = <String, PeerDevice>{};
    final controller = StreamController<List<PeerDevice>>();

    discovery.eventStream?.listen((event) {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        final service = event.service as ResolvedBonsoirService;
        final ip = service.host;

        // Skip self.
        if (ip == _localIp && service.port == 0) return;

        final platform = _parsePlatform(
            service.attributes['platform'] ?? 'unknown');

        final peer = PeerDevice(
          id: '${service.name}_${ip}_${service.port}',
          name: service.name,
          ipAddress: ip ?? '',
          port: service.port,
          platform: platform,
          connectionMethod: ConnectionMethod.wifi,
        );

        if (peer.ipAddress.isNotEmpty) {
          peers[peer.id] = peer;
          controller.add(List.unmodifiable(peers.values));
        }
      } else if (event.type ==
          BonsoirDiscoveryEventType.discoveryServiceLost) {
        final service = event.service;
        peers.removeWhere((key, _) => key.startsWith(service?.name ?? ''));
        controller.add(List.unmodifiable(peers.values));
      }
    });

    yield* controller.stream;
  }

  Future<String?> localIpAddress() => NetworkInfo().getWifiIP();

  PeerPlatform _parsePlatform(String value) => switch (value) {
        'android' => PeerPlatform.android,
        'ios' => PeerPlatform.ios,
        'windows' => PeerPlatform.windows,
        'macos' => PeerPlatform.macos,
        'linux' => PeerPlatform.linux,
        _ => PeerPlatform.unknown,
      };

  void dispose() {
    _broadcast?.stop();
    _discovery?.stop();
    _broadcast = null;
    _discovery = null;
  }
}
