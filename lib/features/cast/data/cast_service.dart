import 'dart:async';

import 'package:dart_cast/dart_cast.dart';
import 'package:logger/logger.dart';

final _log = Logger(printer: SimplePrinter(printTime: false));

/// Wraps [CastService] from dart_cast with app-specific lifecycle management.
class AppCastService {
  AppCastService._();

  static final instance = AppCastService._();

  CastService? _service;
  CastSession? _session;

  final _devicesController = StreamController<List<CastDevice>>.broadcast();
  final _sessionStateController = StreamController<SessionState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  Stream<List<CastDevice>> get devicesStream => _devicesController.stream;
  Stream<SessionState> get sessionStateStream => _sessionStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  CastSession? get activeSession => _session;
  CastDevice? get connectedDevice => _session?.device;
  bool get isConnected =>
      _session != null &&
      _session!.state != SessionState.disconnected;

  SessionState get currentState =>
      _session?.state ?? SessionState.disconnected;

  StreamSubscription<SessionState>? _stateSub;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<List<CastDevice>>? _discoverySub;

  /// Start discovering cast devices on the local network.
  void startDiscovery() {
    _service ??= CastService();
    _discoverySub?.cancel();
    _discoverySub = _service!
        .startDiscovery(timeout: const Duration(seconds: 15))
        .listen(
      (devices) {
        _devicesController.add(devices);
      },
      onError: (Object e) {
        _log.e('Discovery error: $e');
        _devicesController.add([]);
      },
    );
  }

  /// Stop device discovery.
  void stopDiscovery() {
    _discoverySub?.cancel();
    _discoverySub = null;
    _service?.stopDiscovery();
  }

  /// Connect to a cast device.
  Future<void> connect(CastDevice device) async {
    await disconnect();

    _session = await _service!.connect(device);
    await _session!.connect();

    _stateSub = _session!.stateStream.listen((state) {
      _sessionStateController.add(state);
    });
    _posSub = _session!.positionStream.listen((pos) {
      _positionController.add(pos);
    });
    _durSub = _session!.durationStream.listen((dur) {
      _durationController.add(dur);
    });

    _sessionStateController.add(_session!.state);
  }

  /// Cast a local file to the connected device.
  Future<void> castFile({
    required String filePath,
    required CastMediaType mediaType,
    String? title,
    Duration? startPosition,
    Duration? duration,
    List<CastSubtitle> subtitles = const [],
  }) async {
    if (_session == null) {
      throw CastException('No active session');
    }

    final media = CastMedia.file(
      filePath: filePath,
      type: mediaType,
      title: title,
      startPosition: startPosition,
      duration: duration,
      subtitles: subtitles,
    );

    await _session!.loadMedia(media);
  }

  /// Cast a URL to the connected device.
  Future<void> castUrl({
    required String url,
    required CastMediaType mediaType,
    String? title,
    Duration? startPosition,
    List<CastSubtitle> subtitles = const [],
  }) async {
    if (_session == null) {
      throw CastException('No active session');
    }

    final media = CastMedia(
      url: url,
      type: mediaType,
      title: title,
      startPosition: startPosition,
      subtitles: subtitles,
    );

    await _session!.loadMedia(media);
  }

  // ── Playback controls ─────────────────────────────────────────────────

  Future<void> play() async => _session?.play();
  Future<void> pause() async => _session?.pause();
  Future<void> stop() async => _session?.stop();

  Future<void> seek(Duration position) async =>
      _session?.seek(position);

  Future<void> setVolume(double volume) async =>
      _session?.setVolume(volume.clamp(0.0, 1.0));

  Future<void> setSubtitle(CastSubtitle? subtitle) async =>
      _session?.setSubtitle(subtitle);

  Duration get position => _session?.position ?? Duration.zero;
  Duration get duration => _session?.duration ?? Duration.zero;

  /// Disconnect from the current device.
  Future<void> disconnect() async {
    _stateSub?.cancel();
    _posSub?.cancel();
    _durSub?.cancel();

    if (_session != null) {
      try {
        await _session!.disconnect();
      } catch (_) {}
      _session!.dispose();
      _session = null;
    }

    _sessionStateController.add(SessionState.disconnected);
  }

  /// Release all resources.
  Future<void> dispose() async {
    stopDiscovery();
    await disconnect();
    await _service?.dispose();
    _service = null;
    await _devicesController.close();
    await _sessionStateController.close();
    await _positionController.close();
    await _durationController.close();
  }

  /// Determine the CastMediaType from a file extension.
  static CastMediaType mediaTypeFromExtension(String ext) {
    switch (ext.toLowerCase()) {
      case 'mp4':
      case 'm4v':
      case 'mov':
        return CastMediaType.mp4;
      case 'mkv':
        return CastMediaType.mkv;
      case 'ts':
      case 'mts':
      case 'm2ts':
        return CastMediaType.mpegTs;
      default:
        return CastMediaType.mp4;
    }
  }
}
