import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/transfer_job.dart';
import '../providers/transfer_provider.dart';

class TransferProgressCard extends ConsumerWidget {
  const TransferProgressCard({super.key, required this.job});

  final TransferJobEntity job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSend = job.direction == TransferDirection.send;
    final accentColor =
        isSend ? AppColors.transferSend : AppColors.transferReceive;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: job.isCompleted && job.savePath != null
            ? () => _openFile(context, job)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: file name + direction + status ────────────────
            Row(
              children: [
                Icon(
                  isSend ? Icons.upload : Icons.download,
                  color: accentColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    job.fileName,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusChip(status: job.status),
              ],
            ),
            const SizedBox(height: 8),

            // ── Progress bar ──────────────────────────────────────────
            if (job.isActive) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: job.progress,
                  backgroundColor: AppColors.darkDivider,
                  valueColor: AlwaysStoppedAnimation(accentColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
            ],

            // ── Size + speed + ETA ────────────────────────────────────
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${FileSizeFormatter.format(job.bytesTransferred)} / '
                    '${FileSizeFormatter.format(job.fileSize)}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (job.isActive && job.speedFormatted.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.speed, size: 14, color: accentColor),
                  const SizedBox(width: 4),
                  Text(
                    job.speedFormatted,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),

            // ── ETA + peer name ───────────────────────────────────────
            if (job.isActive || job.isCompleted || job.hasFailed) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  if (job.eta != null)
                    Text(
                      'ETA: ${_formatDuration(job.eta!)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  const Spacer(),
                  Text(
                    job.peerName,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],

            // ── Error message ─────────────────────────────────────────
            if (job.hasFailed && job.errorMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                job.errorMessage!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.error),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // ── Action buttons ────────────────────────────────────────
            if (job.isActive || job.canRetry) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (job.isActive) ...[
                    TextButton.icon(
                      icon: const Icon(Icons.pause, size: 14),
                      label: const Text('Pause'),
                      onPressed: () => ref
                          .read(transferManagerProvider.notifier)
                          .pauseJob(job.id),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.cancel, size: 14),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.error),
                      onPressed: () => ref
                          .read(transferManagerProvider.notifier)
                          .cancelJob(job.id),
                    ),
                  ],
                  if (job.canRetry)
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh, size: 14),
                      label: const Text('Retry'),
                      onPressed: () => ref
                          .read(transferManagerProvider.notifier)
                          .retryJob(job.id),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  void _openFile(BuildContext context, TransferJobEntity job) {
    final path = job.savePath!;
    final ext = path.split('.').last.toLowerCase();
    const videoExts = {'mp4', 'mkv', 'avi', 'mov', 'webm', 'flv', '3gp'};
    const audioExts = {'mp3', 'aac', 'flac', 'wav', 'ogg', 'm4a', 'wma'};
    if (videoExts.contains(ext)) {
      context.push('${RouteNames.videoPlayer}?path=${Uri.encodeComponent(path)}');
    } else if (audioExts.contains(ext)) {
      context.push('${RouteNames.audioPlayer}?path=${Uri.encodeComponent(path)}');
    }
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    return '${d.inSeconds}s';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final TransferStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TransferStatus.queued => ('Queued', AppColors.textSecondary),
      TransferStatus.active => ('Active', AppColors.primaryLight),
      TransferStatus.paused => ('Paused', AppColors.warning),
      TransferStatus.completed => ('Done', AppColors.success),
      TransferStatus.failed => ('Failed', AppColors.error),
      TransferStatus.cancelled => ('Cancelled', AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}
