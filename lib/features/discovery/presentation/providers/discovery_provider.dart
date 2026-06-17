import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../transfer/domain/entities/peer_device.dart';
import '../../data/repositories/discovery_repository_impl.dart';
import '../../domain/entities/discovery_state.dart';
import '../../domain/repositories/discovery_repository.dart';

part 'discovery_provider.g.dart';

// ── Repository ───────────────────────────────────────────────────────────────

@riverpod
DiscoveryRepository discoveryRepository(Ref ref) {
  final repo = DiscoveryRepositoryImpl();
  ref.onDispose(repo.dispose);
  return repo;
}

// ── Discovery Notifier ───────────────────────────────────────────────────────

@riverpod
class DeviceDiscovery extends _$DeviceDiscovery {
  Timer? _refreshTimer;
  StreamSubscription<List<PeerDevice>>? _subscription;

  /// How often to restart discovery to catch edge-case stale peers.
  static const _autoRefreshInterval = Duration(seconds: 30);

  @override
  DiscoveryState build() {
    ref.onDispose(_cleanup);

    // Kick off discovery asynchronously; UI sees isScanning = true immediately.
    Future.microtask(_startDiscovery);

    return const DiscoveryState(isScanning: true);
  }

  /// Manually trigger a fresh scan (pull-to-refresh, refresh button).
  Future<void> refresh() async {
    state = state.copyWith(isScanning: true, error: null);

    final repo = ref.read(discoveryRepositoryProvider);
    await repo.restartDiscovery();
  }

  // ── Internal ─────────────────────────────────────────────────────────────

  Future<void> _startDiscovery() async {
    try {
      final repo = ref.read(discoveryRepositoryProvider);

      _subscription = repo.discoverDevices().listen(
        (devices) {
          state = state.copyWith(
            devices: devices,
            isScanning: false,
            lastRefreshed: DateTime.now(),
            error: null,
          );
        },
        onError: (Object e) {
          state = state.copyWith(
            isScanning: false,
            error: e.toString(),
          );
        },
      );

      // Schedule periodic refresh to clear stale peers.
      _refreshTimer?.cancel();
      _refreshTimer = Timer.periodic(_autoRefreshInterval, (_) => refresh());
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: e.toString(),
      );
    }
  }

  void _cleanup() {
    _refreshTimer?.cancel();
    _subscription?.cancel();
    _refreshTimer = null;
    _subscription = null;
  }
}
