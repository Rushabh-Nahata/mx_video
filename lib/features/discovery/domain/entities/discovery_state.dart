import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../transfer/domain/entities/peer_device.dart';

part 'discovery_state.freezed.dart';

/// Represents the current state of device discovery.
@freezed
abstract class DiscoveryState with _$DiscoveryState {
  const DiscoveryState._();

  const factory DiscoveryState({
    @Default([]) List<PeerDevice> devices,
    @Default(false) bool isScanning,
    DateTime? lastRefreshed,
    String? error,
  }) = _DiscoveryState;

  int get deviceCount => devices.length;
  bool get hasDevices => devices.isNotEmpty;
  bool get hasError => error != null;
}
