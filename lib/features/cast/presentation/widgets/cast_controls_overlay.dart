import 'package:dart_cast/dart_cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/duration_formatter.dart';
import '../../data/cast_service.dart';
import '../providers/cast_provider.dart';

/// Full-screen overlay shown when casting — replaces the local video with
/// a remote control UI (play/pause, seek, volume, device info).
class CastControlsOverlay extends ConsumerStatefulWidget {
  const CastControlsOverlay({
    super.key,
    required this.title,
    required this.onDisconnect,
  });

  final String title;
  final VoidCallback onDisconnect;

  @override
  ConsumerState<CastControlsOverlay> createState() =>
      _CastControlsOverlayState();
}

class _CastControlsOverlayState extends ConsumerState<CastControlsOverlay> {
  double _volume = 0.8;

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(castSessionStateProvider);
    final position = ref.watch(castPositionProvider);
    final duration = ref.watch(castDurationProvider);
    final deviceName = ref.watch(castDeviceNameProvider);

    final isPlaying = sessionState == SessionState.playing;
    final isLoading = sessionState == SessionState.loading ||
        sessionState == SessionState.buffering ||
        sessionState == SessionState.connecting;
    final posMs = position.inMilliseconds;
    final durMs = duration.inMilliseconds;

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cast_connected,
                        color: Colors.orangeAccent, size: 22),
                    tooltip: 'Disconnect',
                    onPressed: widget.onDisconnect,
                  ),
                ],
              ),
            ),

            // ── Centre — casting info ───────────────────────────────────
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cast_connected,
                        color: Colors.orangeAccent, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      'Casting to ${deviceName ?? "device"}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // ── Playback controls ───────────────────────────────────────
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: CircularProgressIndicator(color: Colors.white),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _controlBtn(Icons.replay_10, 40, () {
                      final newPos = (posMs - 10000).clamp(0, durMs);
                      AppCastService.instance
                          .seek(Duration(milliseconds: newPos));
                    }),
                    const SizedBox(width: 28),
                    _controlBtn(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      64,
                      () {
                        if (isPlaying) {
                          AppCastService.instance.pause();
                        } else {
                          AppCastService.instance.play();
                        }
                      },
                    ),
                    const SizedBox(width: 28),
                    _controlBtn(Icons.forward_10, 40, () {
                      final newPos = (posMs + 10000).clamp(0, durMs);
                      AppCastService.instance
                          .seek(Duration(milliseconds: newPos));
                    }),
                  ],
                ),
              ),

            // ── Seek bar ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      activeTrackColor: Colors.orangeAccent,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.orangeAccent,
                      overlayColor: Colors.orangeAccent.withAlpha(50),
                    ),
                    child: Slider(
                      value: durMs > 0
                          ? posMs.toDouble().clamp(0, durMs.toDouble())
                          : 0,
                      max: durMs > 0 ? durMs.toDouble() : 1,
                      onChanged: (v) {
                        AppCastService.instance
                            .seek(Duration(milliseconds: v.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          DurationFormatter.format(posMs),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          DurationFormatter.format(durMs),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Volume control ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  const Icon(Icons.volume_down, color: Colors.white70, size: 20),
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 5),
                        activeTrackColor: Colors.white70,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withAlpha(30),
                      ),
                      child: Slider(
                        value: _volume,
                        onChanged: (v) {
                          setState(() => _volume = v);
                          AppCastService.instance.setVolume(v);
                        },
                      ),
                    ),
                  ),
                  const Icon(Icons.volume_up, color: Colors.white70, size: 20),
                ],
              ),
            ),

            // ── Stop casting button ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextButton.icon(
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Stop casting'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
                onPressed: widget.onDisconnect,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlBtn(IconData icon, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: size,
          shadows: const [Shadow(color: Colors.black45, blurRadius: 8)]),
    );
  }
}
