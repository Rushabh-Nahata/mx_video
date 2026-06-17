import 'dart:async';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart' as p;
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../cast/data/cast_service.dart';
import '../../../cast/presentation/widgets/cast_controls_overlay.dart';
import '../../../cast/presentation/widgets/cast_device_picker.dart';
import '../providers/player_provider.dart';
import '../widgets/double_tap_seek_indicator.dart';
import '../widgets/gesture_indicator.dart';
import '../widgets/player_controls.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.filePath,
    this.playlist = const [],
    this.startIndex = 0,
  });

  final String filePath;
  final List<String> playlist;
  final int startIndex;

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>
    with WidgetsBindingObserver {
  VideoController? _videoController;
  final _floating = Floating();

  // ── Gesture state ──────────────────────────────────────────────────────
  double? _dragStartX;
  double _brightness = 0.5;
  double _volume = 0.5;

  bool _showBrightnessIndicator = false;
  bool _showVolumeIndicator = false;
  Timer? _indicatorTimer;

  // ── Double-tap cumulative seek ─────────────────────────────────────────
  bool _showLeftSeek = false;
  bool _showRightSeek = false;
  Timer? _seekTimer;
  int _cumulativeSeekMs = 0;

  // ── Horizontal swipe seek ──────────────────────────────────────────────
  bool _isSeeking = false;
  int _seekPreviewMs = 0;
  double? _hDragStartX;

  // ── Lock mode ──────────────────────────────────────────────────────────
  bool _isLocked = false;

  // ── Cast mode ────────────────────────────────────────────────────────
  bool _isCasting = false;

  String _currentFilePath = '';
  StreamSubscription<String>? _nextVideoSub;

  // ── Init ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enterImmersive();
    WakelockPlus.enable();
    _readInitialBrightnessAndVolume();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPlayer());
  }

  void _enterImmersive() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _readInitialBrightnessAndVolume() async {
    try {
      _brightness = await ScreenBrightness().application;
    } catch (_) {}
    try {
      _volume = await VolumeController.instance.getVolume();
    } catch (_) {}
    VolumeController.instance.addListener((double v) {
      if (mounted) setState(() => _volume = v);
    }, fetchInitialVolume: false);
    if (mounted) setState(() {});
  }

  Future<void> _initPlayer() async {
    _currentFilePath = widget.filePath;
    final notifier = ref.read(playerControllerProvider.notifier);
    await notifier.loadMedia(
      widget.filePath,
      playlist: widget.playlist.isNotEmpty ? widget.playlist : null,
      startIndex: widget.startIndex,
    );
    if (!mounted) return;
    setState(() {
      _videoController = VideoController(notifier.rawSource.player);
    });
    _nextVideoSub = notifier.onNextVideo.listen((nextPath) {
      if (mounted) setState(() => _currentFilePath = nextPath);
    });
    // Auto-hide controls after 1 second on start.
    notifier.showControlsBriefly();
  }

  // ── Dispose ────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _nextVideoSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WakelockPlus.disable();
    ScreenBrightness().resetApplicationScreenBrightness();
    VolumeController.instance.removeListener();
    _indicatorTimer?.cancel();
    _seekTimer?.cancel();
    super.dispose();
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final pipStatus = await _floating.pipStatus;
      if (pipStatus != PiPStatus.enabled) {
        unawaited(ref.read(playerControllerProvider.notifier).pause());
      }
    }
  }

  // ── Gesture handlers ───────────────────────────────────────────────────

  void _onTap() {
    if (_isLocked) return;
    ref.read(playerControllerProvider.notifier).showControlsTemporarily();
  }

  void _onDoubleTapDown(TapDownDetails details) {
    if (_isLocked) return;
    final half = MediaQuery.of(context).size.width / 2;
    final isLeft = details.globalPosition.dx < half;
    final notifier = ref.read(playerControllerProvider.notifier);

    if (isLeft) {
      _cumulativeSeekMs -= 10000;
      notifier.seekBy(-10000);
      _flashSeek(left: true);
    } else {
      _cumulativeSeekMs += 10000;
      notifier.seekBy(10000);
      _flashSeek(left: false);
    }
  }

  void _flashSeek({required bool left}) {
    _seekTimer?.cancel();
    setState(() {
      _showLeftSeek = left;
      _showRightSeek = !left;
    });
    _seekTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _showLeftSeek = _showRightSeek = false;
          _cumulativeSeekMs = 0;
        });
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails d) {
    if (_isLocked) return;
    _dragStartX = d.globalPosition.dx;
  }

  void _onVerticalDragUpdate(DragUpdateDetails d) {
    if (_isLocked || _dragStartX == null) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final delta = -d.delta.dy / (screenWidth * 0.5);

    if (_dragStartX! < screenWidth / 2) {
      _brightness = (_brightness + delta).clamp(0.0, 1.0);
      unawaited(ScreenBrightness().setApplicationScreenBrightness(_brightness));
      setState(() => _showBrightnessIndicator = true);
    } else {
      _volume = (_volume + delta).clamp(0.0, 1.0);
      unawaited(VolumeController.instance.setVolume(_volume));
      setState(() => _showVolumeIndicator = true);
    }

    _indicatorTimer?.cancel();
    _indicatorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showBrightnessIndicator = false;
          _showVolumeIndicator = false;
        });
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails _) => _dragStartX = null;

  // ── Horizontal swipe seek ──────────────────────────────────────────────

  void _onHorizontalDragStart(DragStartDetails d) {
    if (_isLocked) return;
    _hDragStartX = d.globalPosition.dx;
    final playerState = ref.read(playerControllerProvider);
    _seekPreviewMs = playerState.positionMs;
    setState(() => _isSeeking = true);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails d) {
    if (_isLocked || _hDragStartX == null) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final playerState = ref.read(playerControllerProvider);
    // Full screen swipe = ±2 minutes
    final deltaMs = (d.delta.dx / screenWidth * 120000).toInt();
    _seekPreviewMs = (_seekPreviewMs + deltaMs).clamp(0, playerState.durationMs);
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    if (_isLocked) return;
    if (_isSeeking) {
      ref.read(playerControllerProvider.notifier).seekTo(_seekPreviewMs);
    }
    _hDragStartX = null;
    setState(() => _isSeeking = false);
  }

  void _toggleLock() {
    setState(() => _isLocked = !_isLocked);
    if (_isLocked) {
      ref.read(playerControllerProvider.notifier).hideControls();
    }
  }

  Future<void> _handleCast() async {
    if (_isCasting) {
      // Already casting — show cast controls or disconnect
      await AppCastService.instance.disconnect();
      setState(() => _isCasting = false);
      // Resume local playback
      ref.read(playerControllerProvider.notifier).play();
      return;
    }

    // Show device picker
    final device = await CastDevicePicker.show(context);
    if (device == null || !mounted) return;

    try {
      // Pause local playback
      final notifier = ref.read(playerControllerProvider.notifier);
      final playerState = ref.read(playerControllerProvider);
      await notifier.pause();

      // Connect to device
      await AppCastService.instance.connect(device);

      // Determine media type from extension
      final ext = p.extension(_currentFilePath).replaceFirst('.', '');
      final mediaType = AppCastService.mediaTypeFromExtension(ext);

      // Cast the file with resume position
      await AppCastService.instance.castFile(
        filePath: _currentFilePath,
        mediaType: mediaType,
        title: p.basenameWithoutExtension(_currentFilePath),
        startPosition: Duration(milliseconds: playerState.positionMs),
        duration: Duration(milliseconds: playerState.durationMs),
      );

      if (mounted) {
        setState(() => _isCasting = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cast failed: $e')),
        );
        // Resume local playback on failure
        ref.read(playerControllerProvider.notifier).play();
      }
    }
  }

  void _stopCasting() async {
    await AppCastService.instance.stop();
    await AppCastService.instance.disconnect();
    if (mounted) {
      setState(() => _isCasting = false);
      ref.read(playerControllerProvider.notifier).play();
    }
  }

  Future<void> _enterPip() async {
    try {
      final available = await _floating.isPipAvailable;
      if (!available) return;
      await _floating.enable(const ImmediatePiP(
        aspectRatio: Rational.landscape(),
      ));
    } catch (_) {}
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerControllerProvider);
    final notifier = ref.read(playerControllerProvider.notifier);
    final title = p.basenameWithoutExtension(_currentFilePath);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _isLocked ? null : _onTap,
        onDoubleTap: _isLocked ? null : () {},
        onDoubleTapDown: _isLocked ? null : _onDoubleTapDown,
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        onHorizontalDragStart: _onHorizontalDragStart,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video surface ────────────────────────────────────────
            if (_videoController != null)
              Video(
                controller: _videoController!,
                controls: NoVideoControls,
              )
            else
              const SizedBox.shrink(),

            // Buffering spinner is handled inside PlayerControls overlay.

            // ── Horizontal seek preview ──────────────────────────────
            if (_isSeeking)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatMs(_seekPreviewMs),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // ── Brightness indicator (left) ──────────────────────────
            AnimatedOpacity(
              opacity: _showBrightnessIndicator ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: GestureIndicator(
                    icon: _brightness < 0.1
                        ? Icons.brightness_2
                        : _brightness < 0.55
                            ? Icons.brightness_medium
                            : Icons.brightness_high,
                    value: _brightness,
                    label: '${(_brightness * 100).round()}%',
                  ),
                ),
              ),
            ),

            // ── Volume indicator (right) ─────────────────────────────
            AnimatedOpacity(
              opacity: _showVolumeIndicator ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 28),
                  child: GestureIndicator(
                    icon: _volume == 0
                        ? Icons.volume_off
                        : _volume < 0.5
                            ? Icons.volume_down
                            : Icons.volume_up,
                    value: _volume,
                    label: '${(_volume * 100).round()}%',
                  ),
                ),
              ),
            ),

            // ── Double-tap seek indicators (cumulative) ──────────────
            AnimatedOpacity(
              opacity: _showLeftSeek ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Align(
                alignment: const Alignment(-.6, 0),
                child: _CumulativeSeekIndicator(
                  isForward: false,
                  totalMs: _cumulativeSeekMs.abs(),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _showRightSeek ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Align(
                alignment: const Alignment(.6, 0),
                child: _CumulativeSeekIndicator(
                  isForward: true,
                  totalMs: _cumulativeSeekMs.abs(),
                ),
              ),
            ),

            // ── Player controls overlay ──────────────────────────────
            if (!_isLocked)
              AnimatedOpacity(
                opacity: playerState.showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: IgnorePointer(
                  ignoring: !playerState.showControls,
                  child: PlayerControls(
                    state: playerState,
                    title: title,
                    onPlayPause: notifier.playPause,
                    onSeek: notifier.seekTo,
                    onRewind: () => notifier.seekBy(-10000),
                    onFastForward: () => notifier.seekBy(10000),
                    onFullscreen: notifier.toggleFullscreen,
                    onPip: _enterPip,
                    onSpeedChanged: notifier.setSpeed,
                    onSelectAudioTrack: notifier.setAudioTrack,
                    onSelectSubtitleTrack: notifier.setSubtitleTrack,
                    onBack: () => Navigator.of(context).pop(),
                    onLock: _toggleLock,
                    onCast: _handleCast,
                    isCasting: _isCasting,
                    onNext: notifier.hasNext ? notifier.skipNext : null,
                    onPrevious: notifier.hasPrevious ? notifier.skipPrevious : null,
                  ),
                ),
              ),

            // ── Cast controls overlay ──────────────────────────────────
            if (_isCasting)
              CastControlsOverlay(
                title: title,
                onDisconnect: _stopCasting,
              ),

            // ── Lock mode unlock button ──────────────────────────────
            if (_isLocked)
              Positioned(
                right: 16,
                top: MediaQuery.of(context).padding.top + 16,
                child: GestureDetector(
                  onTap: _toggleLock,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.lock_open,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatMs(int ms) {
    final d = Duration(milliseconds: ms);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}

/// Shows cumulative seek amount like "+30s" instead of just "+10s".
class _CumulativeSeekIndicator extends StatelessWidget {
  const _CumulativeSeekIndicator({
    required this.isForward,
    required this.totalMs,
  });

  final bool isForward;
  final int totalMs;

  @override
  Widget build(BuildContext context) {
    final seconds = (totalMs / 1000).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isForward ? Icons.fast_forward : Icons.fast_rewind,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 6),
          Text(
            '${isForward ? '+' : '-'}${seconds}s',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
