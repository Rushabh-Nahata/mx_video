import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/media_file.dart';

enum MediaAction { details, favourite, transfer, share, delete }

/// Bottom sheet with actions for a single media file (long press context menu).
class MediaActionSheet extends StatelessWidget {
  const MediaActionSheet({
    super.key,
    required this.file,
    required this.onAction,
  });

  final MediaFileEntity file;
  final void Function(MediaAction action) onAction;

  static Future<MediaAction?> show(
    BuildContext context,
    MediaFileEntity file,
  ) {
    return showModalBottomSheet<MediaAction>(
      context: context,
      builder: (_) => MediaActionSheet(
        file: file,
        onAction: (action) => Navigator.pop(context, action),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              file.name,
              style: theme.textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Details'),
            onTap: () => onAction(MediaAction.details),
          ),
          ListTile(
            leading: Icon(
              file.isFavourite ? Icons.favorite : Icons.favorite_border,
            ),
            title: Text(file.isFavourite
                ? 'Remove from Favourites'
                : 'Add to Favourites'),
            onTap: () => onAction(MediaAction.favourite),
          ),
          ListTile(
            leading: const Icon(Icons.send_outlined),
            title: const Text('Send via MX Video'),
            subtitle: const Text('Transfer to nearby device'),
            onTap: () => onAction(MediaAction.transfer),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () => onAction(MediaAction.share),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title:
                const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () => onAction(MediaAction.delete),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Bottom sheet shown for bulk actions on multiple selected files.
class BulkActionSheet extends StatelessWidget {
  const BulkActionSheet({
    super.key,
    required this.count,
    required this.onAction,
  });

  final int count;
  final void Function(MediaAction action) onAction;

  static Future<MediaAction?> show(BuildContext context, int count) {
    return showModalBottomSheet<MediaAction>(
      context: context,
      builder: (_) => BulkActionSheet(
        count: count,
        onAction: (action) => Navigator.pop(context, action),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '$count item${count == 1 ? '' : 's'} selected',
              style: theme.textTheme.titleSmall,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('Add to Favourites'),
            onTap: () => onAction(MediaAction.favourite),
          ),
          ListTile(
            leading: const Icon(Icons.send_outlined),
            title: const Text('Send via MX Video'),
            subtitle: const Text('Transfer to nearby device'),
            onTap: () => onAction(MediaAction.transfer),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () => onAction(MediaAction.share),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title:
                const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () => onAction(MediaAction.delete),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Helper functions for performing actions ──────────────────────────────────

Future<void> shareFiles(List<String> paths) async {
  final xFiles = paths.map((p) => XFile(p)).toList();
  await SharePlus.instance.share(ShareParams(files: xFiles));
}

Future<bool> confirmDelete(BuildContext context, int count) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete'),
      content: Text(
        'Are you sure you want to delete $count file${count == 1 ? '' : 's'}? This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<void> deleteFilesFromDisk(List<String> paths) async {
  for (final path in paths) {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
