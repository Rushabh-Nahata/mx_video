import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../shared/widgets/thumbnail_widget.dart';
import '../../domain/entities/media_file.dart';

class VideoDetailsScreen extends StatelessWidget {
  const VideoDetailsScreen({super.key, required this.file});

  final MediaFileEntity file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final stat = File(file.absolutePath).statSync();

    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Thumbnail preview
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ThumbnailWidget(
              path: file.thumbnailPath,
              videoPath: file.isVideo && file.thumbnailPath == null
                  ? file.absolutePath
                  : null,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // File name
          Text(file.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          _DetailRow(label: 'Format', value: file.extension.toUpperCase()),
          _DetailRow(label: 'File Size', value: FileSizeFormatter.format(file.sizeBytes)),
          if (file.durationMs != null)
            _DetailRow(label: 'Duration', value: DurationFormatter.format(file.durationMs!)),
          if (file.width != null && file.height != null)
            _DetailRow(label: 'Resolution', value: '${file.width} × ${file.height}'),
          _DetailRow(
            label: 'File Path',
            value: file.absolutePath,
            onTap: () {
              Clipboard.setData(ClipboardData(text: file.absolutePath));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Path copied to clipboard')),
              );
            },
          ),
          _DetailRow(
            label: 'Date Modified',
            value: _formatDate(stat.modified),
          ),
          _DetailRow(
            label: 'Date Accessed',
            value: _formatDate(stat.accessed),
          ),
          if (file.lastPlayedAt != null)
            _DetailRow(
              label: 'Last Played',
              value: _formatDate(
                DateTime.fromMillisecondsSinceEpoch(file.lastPlayedAt!),
              ),
            ),
          _DetailRow(label: 'Play Count', value: '${file.playCount}'),
          _DetailRow(
            label: 'Favourite',
            value: file.isFavourite ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(153),
                ),
              ),
            ),
            Expanded(
              child: Text(value, style: theme.textTheme.bodyMedium),
            ),
            if (onTap != null)
              Icon(Icons.copy, size: 16, color: cs.onSurface.withAlpha(100)),
          ],
        ),
      ),
    );
  }
}
