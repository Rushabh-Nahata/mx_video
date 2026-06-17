import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../providers/player_provider.dart';
import '../widgets/seek_bar.dart';

class AudioPlayerScreen extends ConsumerStatefulWidget {
  const AudioPlayerScreen({super.key, required this.filePath});

  final String filePath;

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playerControllerProvider.notifier).loadMedia(widget.filePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerControllerProvider);
    final notifier = ref.read(playerControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art placeholder
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.music_note, size: 80, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),

            // Title
            Text(
              widget.filePath.split('/').last,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 32),

            // Seek bar
            SeekBar(
              positionMs: state.positionMs,
              durationMs: state.durationMs,
              onSeek: notifier.seekTo,
            ),

            // Time labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DurationFormatter.format(state.positionMs),
                      style: theme.textTheme.bodySmall),
                  Text(DurationFormatter.format(state.durationMs),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.replay_10),
                  onPressed: () => notifier.seekBy(-10000),
                ),
                IconButton(
                  iconSize: 64,
                  icon: Icon(
                    state.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                  onPressed: notifier.playPause,
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.forward_10),
                  onPressed: () => notifier.seekBy(10000),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
