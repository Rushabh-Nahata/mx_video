import 'package:flutter/material.dart';

import '../../../../core/utils/duration_formatter.dart';
import '../../domain/entities/playback_state.dart';
import 'seek_bar.dart';
import 'speed_sheet.dart';
import 'track_selector_sheet.dart';

/// Full-screen controls overlay — top bar, centre buttons, bottom scrubber row.
class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.state,
    required this.title,
    required this.onPlayPause,
    required this.onSeek,
    required this.onRewind,
    required this.onFastForward,
    required this.onFullscreen,
    required this.onPip,
    required this.onSpeedChanged,
    required this.onSelectAudioTrack,
    required this.onSelectSubtitleTrack,
    required this.onBack,
    this.onLock,
    this.onCast,
    this.isCasting = false,
    this.onNext,
    this.onPrevious,
  });

  final PlaybackState state;
  final String title;
  final VoidCallback onPlayPause;
  final void Function(int positionMs) onSeek;
  final VoidCallback onRewind;
  final VoidCallback onFastForward;
  final VoidCallback onFullscreen;
  final VoidCallback onPip;
  final void Function(double speed) onSpeedChanged;
  final void Function(int index) onSelectAudioTrack;
  final void Function(int index) onSelectSubtitleTrack;
  final VoidCallback onBack;
  final VoidCallback? onLock;
  final VoidCallback? onCast;
  final bool isCasting;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Colors.transparent, Color(0xCC000000)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Column(
        children: [
          // ── Top bar ───────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (state.audioTracks.length > 1)
                    _iconBtn(
                      icon: Icons.headphones,
                      tooltip: 'Audio track',
                      onTap: () => _showAudioTracks(context),
                    ),
                  if (state.subtitleTracks.isNotEmpty)
                    _iconBtn(
                      icon: Icons.closed_caption_outlined,
                      tooltip: 'Subtitles',
                      onTap: () => _showSubtitles(context),
                    ),
                  if (onCast != null)
                    _iconBtn(
                      icon: isCasting ? Icons.cast_connected : Icons.cast,
                      tooltip: isCasting ? 'Casting' : 'Cast',
                      onTap: onCast!,
                    ),
                  if (onLock != null)
                    _iconBtn(
                      icon: Icons.lock_outline,
                      tooltip: 'Lock',
                      onTap: onLock!,
                    ),
                ],
              ),
            ),
          ),

          // ── Centre buttons ────────────────────────────────────────────
          Expanded(
            child: Center(
              child: state.isLoading
                  ? const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Previous
                        if (onPrevious != null)
                          _centreBtn(
                            icon: Icons.skip_previous,
                            size: 36,
                            onTap: onPrevious!,
                          ),
                        if (onPrevious != null) const SizedBox(width: 24),
                        _centreBtn(
                          icon: Icons.replay_10,
                          size: 40,
                          onTap: onRewind,
                        ),
                        const SizedBox(width: 28),
                        _centreBtn(
                          icon: state.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 64,
                          onTap: onPlayPause,
                        ),
                        const SizedBox(width: 28),
                        _centreBtn(
                          icon: Icons.forward_10,
                          size: 40,
                          onTap: onFastForward,
                        ),
                        // Next
                        if (onNext != null) const SizedBox(width: 24),
                        if (onNext != null)
                          _centreBtn(
                            icon: Icons.skip_next,
                            size: 36,
                            onTap: onNext!,
                          ),
                      ],
                    ),
            ),
          ),

          // ── Bottom bar ────────────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SeekBar(
                    positionMs: state.positionMs,
                    durationMs: state.durationMs,
                    onSeek: onSeek,
                  ),
                  Row(
                    children: [
                      Text(
                        DurationFormatter.format(state.positionMs),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      const Text('/',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        DurationFormatter.format(state.durationMs),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      const Spacer(),
                      // Speed
                      InkWell(
                        onTap: () => SpeedSheet.show(
                          context: context,
                          currentSpeed: state.speed,
                          onSelect: onSpeedChanged,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Text(
                            state.speed == 1.0
                                ? '1\u00d7'
                                : '${state.speed}\u00d7',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // PiP
                      _iconBtn(
                        icon: Icons.picture_in_picture_alt,
                        tooltip: 'Picture in Picture',
                        onTap: onPip,
                        size: 20,
                      ),
                      // Fullscreen
                      _iconBtn(
                        icon: state.isFullscreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        tooltip: state.isFullscreen
                            ? 'Exit fullscreen'
                            : 'Fullscreen',
                        onTap: onFullscreen,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Track sheet helpers ────────────────────────────────────────────────

  void _showAudioTracks(BuildContext context) {
    TrackSelectorSheet.show(
      context: context,
      title: 'Audio Track',
      tracks: state.audioTracks,
      selectedIndex: state.selectedAudioTrack,
      onSelect: onSelectAudioTrack,
    );
  }

  void _showSubtitles(BuildContext context) {
    final tracks = [
      const TrackInfo(index: -1, label: 'Off'),
      ...state.subtitleTracks,
    ];
    TrackSelectorSheet.show(
      context: context,
      title: 'Subtitles',
      tracks: tracks,
      selectedIndex: state.selectedSubtitleTrack,
      onSelect: onSelectSubtitleTrack,
    );
  }

  // ── Widget helpers ─────────────────────────────────────────────────────

  static Widget _iconBtn({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    double size = 22,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: size),
      tooltip: tooltip,
      onPressed: onTap,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
    );
  }

  static Widget _centreBtn({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: size,
          shadows: const [Shadow(color: Colors.black45, blurRadius: 8)]),
    );
  }
}
