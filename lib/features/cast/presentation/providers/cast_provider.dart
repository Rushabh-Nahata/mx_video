import 'dart:async';

import 'package:dart_cast/dart_cast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/cast_service.dart';

part 'cast_provider.g.dart';

// ── Cast device discovery ───────────────────────────────────────────────────

@riverpod
class CastDiscovery extends _$CastDiscovery {
  StreamSubscription<List<CastDevice>>? _sub;

  @override
  List<CastDevice> build() {
    ref.onDispose(() {
      _sub?.cancel();
      AppCastService.instance.stopDiscovery();
    });
    return [];
  }

  void startDiscovery() {
    _sub?.cancel();
    AppCastService.instance.startDiscovery();
    _sub = AppCastService.instance.devicesStream.listen((devices) {
      state = devices;
    });
  }

  void stopDiscovery() {
    _sub?.cancel();
    _sub = null;
    AppCastService.instance.stopDiscovery();
  }
}

// ── Cast session state ──────────────────────────────────────────────────────

@riverpod
class CastSessionState extends _$CastSessionState {
  StreamSubscription<SessionState>? _sub;

  @override
  SessionState build() {
    ref.onDispose(() => _sub?.cancel());
    _sub = AppCastService.instance.sessionStateStream.listen((s) {
      state = s;
    });
    return AppCastService.instance.currentState;
  }
}

// ── Cast position ───────────────────────────────────────────────────────────

@riverpod
class CastPosition extends _$CastPosition {
  StreamSubscription<Duration>? _sub;

  @override
  Duration build() {
    ref.onDispose(() => _sub?.cancel());
    _sub = AppCastService.instance.positionStream.listen((pos) {
      state = pos;
    });
    return AppCastService.instance.position;
  }
}

// ── Cast duration ───────────────────────────────────────────────────────────

@riverpod
class CastDuration extends _$CastDuration {
  StreamSubscription<Duration>? _sub;

  @override
  Duration build() {
    ref.onDispose(() => _sub?.cancel());
    _sub = AppCastService.instance.durationStream.listen((dur) {
      state = dur;
    });
    return AppCastService.instance.duration;
  }
}

// ── Connected device name ───────────────────────────────────────────────────

@riverpod
class CastDeviceName extends _$CastDeviceName {
  @override
  String? build() {
    return AppCastService.instance.connectedDevice?.name;
  }

  void set(String? name) => state = name;
}
