import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/status_item.dart';

class StatusGridTile extends StatelessWidget {
  const StatusGridTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onSave,
    this.onDelete,
    this.showSaveButton = true,
  });

  final StatusItem item;
  final VoidCallback onTap;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final bool showSaveButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            if (item.isImage)
              Image.file(
                File(item.path),
                fit: BoxFit.cover,
                cacheWidth: 300,
                errorBuilder: (_, _, _) => _placeholder(cs),
              )
            else
              _VideoThumbnail(path: item.path),

            // Video play icon overlay
            if (item.isVideo)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black45,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 32,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
            ),

            // Save / Delete button
            if (showSaveButton && !item.isSaved && onSave != null)
              Positioned(
                bottom: 4,
                right: 4,
                child: _ActionButton(
                  icon: Icons.download,
                  color: Colors.white,
                  onTap: onSave!,
                ),
              ),
            if (!showSaveButton && onDelete != null)
              Positioned(
                bottom: 4,
                right: 4,
                child: _ActionButton(
                  icon: Icons.delete_outline,
                  color: Colors.redAccent,
                  onTap: onDelete!,
                ),
              ),

            // Saved badge
            if (item.isSaved && showSaveButton)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(200),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Saved',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),

            // Type badge (top-right for videos)
            if (item.isVideo)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam, color: Colors.white, size: 12),
                      SizedBox(width: 2),
                      Text(
                        'Video',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme cs) {
    return ColoredBox(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(
          item.isVideo ? Icons.videocam_outlined : Icons.image_outlined,
          color: cs.onSurface.withAlpha(100),
          size: 32,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

/// Attempts to show a video thumbnail frame, falls back to placeholder.
class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // For video statuses, show a themed placeholder since we can't
    // generate thumbnails without the ThumbnailQueue's video path.
    // The actual video frame is shown when the user taps to preview.
    return ColoredBox(
      color: cs.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.videocam_outlined,
          color: cs.onSurface.withAlpha(100),
          size: 32,
        ),
      ),
    );
  }
}
