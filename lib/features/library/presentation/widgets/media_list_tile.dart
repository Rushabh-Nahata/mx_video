import 'package:flutter/material.dart';

import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../shared/widgets/thumbnail_widget.dart';
import '../../domain/entities/media_file.dart';

class MediaListTile extends StatelessWidget {
  const MediaListTile({
    super.key,
    required this.file,
    required this.onTap,
    this.onLongPress,
  });

  final MediaFileEntity file;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final progress = file.durationMs != null && file.durationMs! > 0
        ? (file.playPositionMs / file.durationMs!).clamp(0.0, 1.0)
        : 0.0;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Thumbnail ──────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  ThumbnailWidget(
                    path: file.thumbnailPath,
                    videoPath: file.isVideo && file.thumbnailPath == null
                        ? file.absolutePath
                        : null,
                    width: 80,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                  // Resume progress bar
                  if (progress > 0.01)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 3,
                        backgroundColor: Colors.black38,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          cs.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ── Text ───────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    file.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Favourite + trailing icon ─────────────────────────────────
            if (file.isFavourite)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.favorite, size: 16, color: cs.primary),
              ),
            Icon(
              file.isVideo
                  ? Icons.play_circle_outline
                  : Icons.music_note_outlined,
              size: 22,
              color: cs.onSurface.withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    final parts = <String>[FileSizeFormatter.format(file.sizeBytes)];
    if (file.durationMs != null) {
      parts.add(DurationFormatter.format(file.durationMs!));
    }
    return parts.join(' · ');
  }
}
