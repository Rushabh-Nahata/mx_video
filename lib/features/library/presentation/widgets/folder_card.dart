import 'package:flutter/material.dart';

import '../../../../shared/widgets/thumbnail_widget.dart';
import '../../domain/entities/media_folder.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
  });

  final MediaFolderEntity folder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: ThumbnailWidget(
                path: folder.thumbnailPath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folder.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    final parts = <String>[];
    if (folder.videoCount > 0) {
      parts.add('${folder.videoCount} video${folder.videoCount > 1 ? 's' : ''}');
    }
    if (folder.audioCount > 0) {
      parts.add('${folder.audioCount} audio');
    }
    return parts.isEmpty ? 'Empty' : parts.join(' · ');
  }
}
