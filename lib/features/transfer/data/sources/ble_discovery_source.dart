import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/peer_device.dart';

final _log = Logger(printer: SimplePrinter());

/// Discovers nearby MX Video devices using Bluetooth Low Energy.
///
/// BLE is used for **discovery only** — actual file transfer happens over
/// WiFi/HTTP. This enables finding peers even when they're not on the
/// same WiFi network.
///
/// Scanning (central mode): Uses flutter_blue_plus to scan for devices
/// advertising the MX Video BLE service UUID.
///
/// Advertising (peripheral mode): Requires native platform code.
/// See native implementations in android/ and ios/ directories.
class BleDiscoverySource {
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final _peers = <String, PeerDevice>{};

  /// Whether Bluetooth is available and turned on.
  Future<bool> get isAvailable async {
    try {
      final supported = await FlutterBluePlus.isSupported;
      if (!supported) return false;
      final state = FlutterBluePlus.adapterStateNow;
      return state == BluetoothAdapterState.on;
    } catch (_) {
      return false;
    }
  }

  /// Stream of discovered BLE peers.
  ///
  /// Each device advertises its connection info in the BLE advertisement
  /// manufacturer data with the MX Video manufacturer ID (0x4D58).
  ///
  /// Manufacturer data format:
  ///   [1 byte platform] [4 bytes IPv4] [2 bytes port] [remaining: UTF-8 name]
  Stream<List<PeerDevice>> discoverPeers() {
    final controller = StreamController<List<PeerDevice>>();

    _startScan(controller);

    controller.onCancel = () {
      stopDiscovery();
    };

    return controller.stream;
  }

  Future<void> _startScan(StreamController<List<PeerDevice>> controller) async {
    if (!await isAvailable) {
      _log.w('BLE: Bluetooth not available or turned off');
      controller.add([]);
      return;
    }

    try {
      // Scan for devices with our specific service UUID.
      await FlutterBluePlus.startScan(
        timeout: AppConstants.bleScanDuration,
        withServices: [Guid(AppConstants.bleServiceUuid)],
      );

      _scanSubscription = FlutterBluePlus.onScanResults.listen(
        (results) {
          for (final result in results) {
            final peer = _parseScanResult(result);
            if (peer != null) {
              _peers[peer.id] = peer;
            }
          }
          controller.add(List.unmodifiable(_peers.values));
        },
        onError: (e) {
          _log.e('BLE scan error: $e');
        },
      );

      // When scan completes, restart after a short delay for continuous discovery.
      FlutterBluePlus.isScanning.listen((scanning) async {
        if (!scanning && !controller.isClosed) {
          await Future.delayed(const Duration(seconds: 2));
          if (!controller.isClosed) {
            try {
              await FlutterBluePlus.startScan(
                timeout: AppConstants.bleScanDuration,
                withServices: [Guid(AppConstants.bleServiceUuid)],
              );
            } catch (_) {
              // Scan may fail if BT was turned off.
            }
          }
        }
      });
    } catch (e) {
      _log.e('BLE: Failed to start scan: $e');
      controller.add([]);
    }
  }

  /// Parse a BLE scan result into a PeerDevice.
  ///
  /// Looks for manufacturer data with MX Video's manufacturer ID.
  PeerDevice? _parseScanResult(ScanResult result) {
    final mfData = result.advertisementData.manufacturerData;
    final mxData = mfData[AppConstants.bleManufacturerId];

    if (mxData == null || mxData.length < 7) return null;

    try {
      // Parse: [platform(1)] [ip(4)] [port(2)] [name(rest)]
      final platform = _parsePlatform(mxData[0]);
      final ip = '${mxData[1]}.${mxData[2]}.${mxData[3]}.${mxData[4]}';
      final port = (mxData[5] << 8) | mxData[6];
      final name = mxData.length > 7
          ? utf8.decode(mxData.sublist(7))
          : result.device.platformName;

      // IP 0.0.0.0 means the peer is nearby but not on the same network.
      final hasIp = ip != '0.0.0.0';

      return PeerDevice(
        id: 'ble_${result.device.remoteId.str}',
        name: name.isNotEmpty ? name : 'Nearby Device',
        ipAddress: hasIp ? ip : '',
        port: hasIp ? port : 0,
        platform: platform,
        connectionMethod: ConnectionMethod.bluetooth,
      );
    } catch (e) {
      _log.w('BLE: Failed to parse scan result: $e');
      return null;
    }
  }

  PeerPlatform _parsePlatform(int value) => switch (value) {
        0 => PeerPlatform.android,
        1 => PeerPlatform.ios,
        2 => PeerPlatform.windows,
        3 => PeerPlatform.macos,
        4 => PeerPlatform.linux,
        _ => PeerPlatform.unknown,
      };

  Future<void> stopDiscovery() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {}
    _peers.clear();
  }

  void dispose() {
    stopDiscovery();
  }
}
