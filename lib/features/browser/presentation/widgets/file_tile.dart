import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/entities/folder_node.dart';

/// A single row in the file browser — can represent a folder or a file.
class FileTile extends StatelessWidget {
  const FileTile._({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  factory FileTile.folder({
    Key? key,
    required FolderNode node,
    required VoidCallback onTap,
  }) =>
      FileTile._(
        key: key,
        onTap: onTap,
        icon: Icons.folder,
        iconColor: const Color(0xFFFFA726),
        title: node.name,
        subtitle: '${node.childCount} item${node.childCount != 1 ? 's' : ''}',
      );

  factory FileTile.file({
    Key? key,
    required FileNode node,
    required VoidCallback onTap,
  }) =>
      FileTile._(
        key: key,
        onTap: onTap,
        icon: node.isVideo
            ? Icons.videocam_outlined
            : node.isAudio
                ? Icons.music_note_outlined
                : Icons.insert_drive_file_outlined,
        iconColor: node.isVideo
            ? AppColors.primaryLight
            : node.isAudio
                ? AppColors.accent
                : AppColors.textSecondary,
        title: node.name,
        subtitle: FileSizeFormatter.format(node.sizeBytes),
        trailing: node.isMedia ? const Icon(Icons.play_arrow, size: 18) : null,
      );

  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(title, style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      trailing: trailing,
    );
  }
}
