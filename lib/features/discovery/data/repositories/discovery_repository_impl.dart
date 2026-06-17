import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../transfer/domain/entities/peer_device.dart';
import '../../domain/repositories/discovery_repository.dart';

final _log = Logger(printer: SimplePrinter());

/// mDNS/Bonjour implementation of [DiscoveryRepository].
///
/// Uses [BonsoirDiscovery] which wraps platform-native mDNS:
///   - Android: NsdManager
///   - iOS: NetService (Bonjour)
class DiscoveryRepositoryImpl implements DiscoveryRepository {
  BonsoirDiscovery? _discovery;
  StreamController<List<PeerDevice>>? _controller;
  final _peers = <String, PeerDevice>{};
  String? _localIp;

  @override
  Stream<List<PeerDevice>> discoverDevices() {
    if (_controller != null && !_controller!.isClosed) {
      return _controller!.stream;
    }

    _controller = StreamController<List<PeerDevice>>.broadcast(
      onListen: _startSession,
      onCancel: _stopSession,
    );

    return _controller!.stream;
  }

  @override
  Future<void> restartDiscovery() async {
    await _stopSession();
    _peers.clear();
    _controller?.add([]);
    await _startSession();
  }

  Future<void> _startSession() async {
    try {
      _localIp = await NetworkInfo().getWifiIP();

      final discovery = BonsoirDiscovery(type: AppConstants.mdnsServiceType);
      _discovery = discovery;
      await discovery.ready;
      await discovery.start();

      _log.i('Discovery: mDNS scan started');

      discovery.eventStream?.listen(
        _handleEvent,
        onError: (Object e) {
          _log.e('Discovery: mDNS stream error: $e');
          _controller?.addError(e);
        },
      );
    } catch (e) {
      _log.e('Discovery: failed to start mDNS: $e');
      _controller?.addError(e);
    }
  }

  void _handleEvent(BonsoirDiscoveryEvent event) {
    switch (event.type) {
      case BonsoirDiscoveryEventType.discoveryServiceResolved:
        final service = event.service as ResolvedBonsoirService;
        final ip = service.host;

        // Don't discover ourselves.
        if (ip == _localIp) return;

        final peer = PeerDevice(
          id: '${service.name}_${ip}_${service.port}',
          name: service.name,
          ipAddress: ip ?? '',
          port: service.port,
          platform: _parsePlatform(
            service.attributes['platform'] ?? 'unknown',
          ),
          connectionMethod: ConnectionMethod.wifi,
        );

        if (peer.ipAddress.isNotEmpty) {
          _peers[peer.id] = peer;
          _emit();
        }

      case BonsoirDiscoveryEventType.discoveryServiceLost:
        final name = event.service?.name ?? '';
        _peers.removeWhere((key, _) => key.startsWith(name));
        _emit();

      default:
        break;
    }
  }

  void _emit() {
    _controller?.add(List.unmodifiable(_peers.values));
  }

  Future<void> _stopSession() async {
    await _discovery?.stop();
    _discovery = null;
  }

  @override
  void dispose() {
    _discovery?.stop();
    _controller?.close();
    _discovery = null;
    _controller = null;
    _peers.clear();
  }

  PeerPlatform _parsePlatform(String value) => switch (value) {
        'android' => PeerPlatform.android,
        'ios' => PeerPlatform.ios,
        'windows' => PeerPlatform.windows,
        'macos' => PeerPlatform.macos,
        'linux' => PeerPlatform.linux,
        _ => PeerPlatform.unknown,
      };
}
