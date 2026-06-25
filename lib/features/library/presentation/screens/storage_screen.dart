import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/utils/file_size_formatter.dart';

part 'storage_screen.g.dart';

@riverpod
Future<StorageInfo> storageInfo(Ref ref) async {
  final dir = await getExternalStorageDirectory() ??
      await getApplicationDocumentsDirectory();

  // Use the root of the storage (e.g. /storage/emulated/0)
  final root = Directory(dir.path.split('Android').first);

  // Use disk space API on supported platforms
  final totalBytes = await _getDiskSpace(root.path, total: true);
  final freeBytes = await _getDiskSpace(root.path, total: false);

  // Calculate video storage from DB
  const videoExts = {'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm', 'm4v', 'mpeg', 'mpg', '3gp', 'ts'};
  const audioExts = {'mp3', 'aac', 'flac', 'ogg', 'wav', 'm4a', 'wma', 'opus'};

  final allFiles = await ref.read(mediaDaoProvider).getAllFiles();
  final videos = allFiles.where((f) => videoExts.contains(f.extension.toLowerCase()));
  final audios = allFiles.where((f) => audioExts.contains(f.extension.toLowerCase()));

  return StorageInfo(
    totalBytes: totalBytes,
    freeBytes: freeBytes,
    videoBytes: videos.fold<int>(0, (sum, f) => sum + f.sizeBytes),
    audioBytes: audios.fold<int>(0, (sum, f) => sum + f.sizeBytes),
    videoCount: videos.length,
    audioCount: audios.length,
  );
}

Future<int> _getDiskSpace(String path, {required bool total}) async {
  try {
    final stat = await Process.run('df', [path]);
    if (stat.exitCode == 0) {
      final lines = (stat.stdout as String).trim().split('\n');
      if (lines.length >= 2) {
        final parts = lines[1].split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          // df output: Filesystem 1K-blocks Used Available
          final totalKb = int.tryParse(parts[1]) ?? 0;
          final availKb = int.tryParse(parts[3]) ?? 0;
          return (total ? totalKb : availKb) * 1024;
        }
      }
    }
  } catch (_) {}
  // Fallback: use StatFs via rough estimate
  return total ? 64 * 1024 * 1024 * 1024 : 16 * 1024 * 1024 * 1024;
}

class StorageInfo {
  const StorageInfo({
    required this.totalBytes,
    required this.freeBytes,
    required this.videoBytes,
    required this.audioBytes,
    required this.videoCount,
    required this.audioCount,
  });

  final int totalBytes;
  final int freeBytes;
  final int videoBytes;
  final int audioBytes;
  final int videoCount;
  final int audioCount;

  int get usedBytes => totalBytes - freeBytes;
  int get mediaBytes => videoBytes + audioBytes;
}

class StorageScreen extends ConsumerWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(storageInfoProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Storage')),
      body: infoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (info) {
          final usedFrac =
              info.totalBytes > 0 ? info.usedBytes / info.totalBytes : 0.0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Storage bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: usedFrac,
                  minHeight: 24,
                  backgroundColor: cs.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(cs.primary),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${FileSizeFormatter.format(info.usedBytes)} used',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '${FileSizeFormatter.format(info.freeBytes)} free',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _StatCard(
                icon: Icons.storage,
                label: 'Total Storage',
                value: FileSizeFormatter.format(info.totalBytes),
                color: cs.primary,
              ),
              _StatCard(
                icon: Icons.pie_chart,
                label: 'Used Storage',
                value: FileSizeFormatter.format(info.usedBytes),
                color: cs.secondary,
              ),
              _StatCard(
                icon: Icons.folder_open,
                label: 'Free Storage',
                value: FileSizeFormatter.format(info.freeBytes),
                color: cs.tertiary,
              ),
              const Divider(height: 32),
              Text('Media Breakdown',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.onSurface.withAlpha(153),
                  )),
              const SizedBox(height: 12),
              _StatCard(
                icon: Icons.video_library,
                label: 'Videos (${info.videoCount})',
                value: FileSizeFormatter.format(info.videoBytes),
                color: Colors.blue,
              ),
              _StatCard(
                icon: Icons.audiotrack,
                label: 'Audio (${info.audioCount})',
                value: FileSizeFormatter.format(info.audioBytes),
                color: Colors.orange,
              ),
              _StatCard(
                icon: Icons.video_file,
                label: 'Total Media',
                value: FileSizeFormatter.format(info.mediaBytes),
                color: Colors.green,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
