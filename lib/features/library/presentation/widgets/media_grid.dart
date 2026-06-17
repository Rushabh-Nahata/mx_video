import 'package:flutter/material.dart';

import '../../domain/entities/media_file.dart';
import 'media_list_tile.dart';

/// A sliver-based grid of [MediaFileEntity] items.
/// Used inside CustomScrollView for library screens.
class MediaGrid extends StatelessWidget {
  const MediaGrid({
    super.key,
    required this.files,
    required this.onFileTap,
  });

  final List<MediaFileEntity> files;
  final void Function(MediaFileEntity file) onFileTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => MediaListTile(
          file: files[i],
          onTap: () => onFileTap(files[i]),
        ),
        childCount: files.length,
      ),
    );
  }
}
