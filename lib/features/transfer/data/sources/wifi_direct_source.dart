import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/peer_device.dart';

final _log = Logger(printer: SimplePrinter());

/// Android WiFi Direct (P2P) peer discovery and group management.
///
/// Uses a MethodChannel to communicate with native Kotlin/Swift code.
/// On iOS, AWDL is system-restricted — this source gracefully degrades.
///
/// WiFi Direct creates a direct WiFi link between two Android devices
/// without a router. One device becomes the Group Owner (GO) and
/// assigns IP addresses. Transfer then proceeds over HTTP as usual.
class WifiDirectSource {
  static const _channel = MethodChannel('mx_video/wifi_direct');

  final _peersController = StreamController<List<PeerDevice>>.broadcast();
  bool _isDiscovering = false;

  WifiDirectSource() {
    _channel.setMethodCallHandler(_handleNativeCallback);
  }

  bool get isDiscovering => _isDiscovering;

  /// Start WiFi Direct peer discovery.
  /// Discovered peers are emitted on the [peers] stream.
  Future<void> startDiscovery() async {
    try {
      await _channel.invokeMethod('startDiscovery');
      _isDiscovering = true;
      _log.i('WiFi Direct: discovery started');
    } on PlatformException catch (e) {
      if (e.code == 'UNSUPPORTED') {
        _log.w('WiFi Direct: not supported on this device');
      } else {
        _log.e('WiFi Direct: discovery failed: $e');
        rethrow;
      }
    }
  }

  Future<void> stopDiscovery() async {
    _isDiscovering = false;
    try {
      await _channel.invokeMethod('stopDiscovery');
    } on PlatformException {
      // Ignore.
    }
  }

  /// Stream of discovered WiFi Direct peers.
  Stream<List<PeerDevice>> get peers => _peersController.stream;

  /// Request connection to a WiFi Direct peer.
  /// Returns the Group Owner IP address on success.
  Future<String?> connectToPeer(String deviceAddress) async {
    try {
      final result = await _channel.invokeMethod<Map>(
        'connectToPeer',
        {'address': deviceAddress},
      );

      if (result == null) return null;

      return result['groupOwnerIp'] as String?;
    } on PlatformException catch (e) {
      _log.e('WiFi Direct: connect failed: $e');
      return null;
    }
  }

  /// Create a WiFi Direct group (become Group Owner).
  /// Returns the GO IP address.
  Future<String?> createGroup() async {
    try {
      return await _channel.invokeMethod<String>('createGroup');
    } on PlatformException catch (e) {
      _log.e('WiFi Direct: create group failed: $e');
      return null;
    }
  }

  /// Remove the current WiFi Direct group.
  Future<void> removeGroup() async {
    try {
      await _channel.invokeMethod('removeGroup');
    } on PlatformException {
      // Ignore.
    }
  }

  Future<void> disconnect() async {
    try {
      await _channel.invokeMethod('disconnect');
    } on PlatformException {
      // Ignore.
    }
  }

  /// Handle callbacks from native code (peer list updates, connection changes).
  Future<void> _handleNativeCallback(MethodCall call) async {
    switch (call.method) {
      case 'onPeersChanged':
        final rawPeers = call.arguments as List<dynamic>? ?? [];
        final peers = rawPeers.map<PeerDevice>((raw) {
          final map = Map<String, dynamic>.from(raw as Map);
          return PeerDevice(
            id: 'wifid_${map['address']}',
            name: map['name'] as String? ?? 'WiFi Direct Device',
            ipAddress: '', // IP is assigned after connection
            port: 0,
            platform: PeerPlatform.android,
            connectionMethod: ConnectionMethod.wifiDirect,
          );
        }).toList();
        _peersController.add(peers);

      case 'onConnectionChanged':
        final info = Map<String, dynamic>.from(call.arguments as Map);
        _log.i('WiFi Direct: connection changed: $info');
    }
  }

  void dispose() {
    stopDiscovery();
    _peersController.close();
  }
}
