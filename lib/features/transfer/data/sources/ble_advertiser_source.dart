import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

final _log = Logger(printer: SimplePrinter());

/// Dart wrapper for the native BLE advertiser plugin.
///
/// Enables this device to advertise itself via BLE so that peers
/// (including cross-platform: iOS ↔ Android) can discover it
/// even when not on the same WiFi network.
///
/// Uses platform channels to native code:
///   - Android: BleAdvertiserPlugin.kt (BluetoothLeAdvertiser)
///   - iOS: BleAdvertiserPlugin.swift (CBPeripheralManager)
class BleAdvertiserSource {
  static const _channel = MethodChannel('mx_video/ble_advertiser');

  bool _isAdvertising = false;

  bool get isAdvertising => _isAdvertising;

  /// Check if BLE advertising is available on this device.
  Future<bool> get isAvailable async {
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } catch (e) {
      _log.w('BLE advertiser: isAvailable check failed: $e');
      return false;
    }
  }

  /// Start advertising this device as an MX Video peer.
  ///
  /// [name]: Device display name (e.g. "iPhone 15" or "Pixel 8")
  /// [ip]: Local WiFi IP address (e.g. "192.168.1.100")
  /// [port]: Transfer server port number
  Future<bool> startAdvertising({
    required String name,
    required String ip,
    required int port,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('startAdvertising', {
        'name': name,
        'ip': ip,
        'port': port,
      });
      _isAdvertising = result ?? false;
      if (_isAdvertising) {
        _log.i('BLE advertiser: started advertising "$name"');
      }
      return _isAdvertising;
    } catch (e) {
      _log.e('BLE advertiser: failed to start: $e');
      _isAdvertising = false;
      return false;
    }
  }

  /// Stop BLE advertising.
  Future<void> stopAdvertising() async {
    try {
      await _channel.invokeMethod<void>('stopAdvertising');
      _isAdvertising = false;
      _log.i('BLE advertiser: stopped');
    } catch (e) {
      _log.w('BLE advertiser: failed to stop: $e');
    }
  }

  void dispose() {
    stopAdvertising();
  }
}
