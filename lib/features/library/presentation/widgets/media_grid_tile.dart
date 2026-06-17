import 'package:flutter/material.dart';

import '../../../../core/utils/duration_formatter.dart';
import '../../../../shared/widgets/thumbnail_widget.dart';
import '../../domain/entities/media_file.dart';

/// Compact grid tile for media files — shows thumbnail with name overlay.
class MediaGridTile extends StatelessWidget {
  const MediaGridTile({
    super.key,
    required this.file,
    required this.onTap,
    this.onLongPress,
    this.isSelecting = false,
    this.isSelected = false,
  });

  final MediaFileEntity file;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelecting;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final duration = file.durationMs != null
        ? DurationFormatter.format(file.durationMs!)
        : null;
    final progress = file.durationMs != null && file.durationMs! > 0
        ? (file.playPositionMs / file.durationMs!).clamp(0.0, 1.0)
        : 0.0;

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            ThumbnailWidget(
              path: file.thumbnailPath,
              videoPath:
                  file.isVideo && file.thumbnailPath == null ? file.absolutePath : null,
              fit: BoxFit.cover,
            ),

            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 48,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
            ),

            // File name
            Positioned(
              bottom: 4,
              left: 6,
              right: 6,
              child: Text(
                file.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Duration badge
            if (duration != null)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),

            // Media type icon
            if (!file.isVideo)
              Positioned(
                top: 4,
                left: 4,
                child: Icon(
                  Icons.music_note,
                  size: 16,
                  color: Colors.white.withAlpha(200),
                ),
              ),

            // Progress bar
            if (progress > 0.01)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                ),
              ),

            // Selection indicator
            if (isSelecting)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? cs.primary
                        : cs.surfaceContainerHighest.withAlpha(200),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    isSelected ? Icons.check : Icons.circle_outlined,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.white60,
                  ),
                ),
              ),

            // Favourite indicator
            if (file.isFavourite)
              Positioned(
                top: 4,
                right: duration != null ? 50 : 4,
                child: Icon(Icons.favorite, size: 14, color: cs.primary),
              ),
          ],
        ),
      ),
    );
  }
}
