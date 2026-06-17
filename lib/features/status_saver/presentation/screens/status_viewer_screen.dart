import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/route_names.dart';
import '../../domain/entities/status_item.dart';

/// Full-screen viewer for a status item.
/// Images are shown with pinch-to-zoom; videos navigate to the video player.
class StatusViewerScreen extends StatelessWidget {
  const StatusViewerScreen({
    super.key,
    required this.item,
    this.onSave,
  });

  final StatusItem item;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          _formatDate(item.dateModified),
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          if (!item.isSaved && onSave != null)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Save',
              onPressed: () {
                onSave!();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Status saved'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(files: [XFile(item.path)]),
              );
            },
          ),
        ],
      ),
      body: item.isImage ? _ImageViewer(path: item.path) : _VideoPrompt(item: item),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);

    if (date == today) {
      return 'Today ${_time(dt)}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${_time(dt)}';
    }
    return '${dt.day}/${dt.month}/${dt.year} ${_time(dt)}';
  }

  String _time(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.file(
          File(path),
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.broken_image,
            color: Colors.white38,
            size: 64,
          ),
        ),
      ),
    );
  }
}

class _VideoPrompt extends StatelessWidget {
  const _VideoPrompt({required this.item});
  final StatusItem item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.videocam, color: Colors.white38, size: 64),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play Video'),
            onPressed: () {
              context.push(
                '${RouteNames.videoPlayer}?path=${Uri.encodeComponent(item.path)}',
              );
            },
          ),
        ],
      ),
    );
  }
}
