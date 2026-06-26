import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../services/transfer_orchestrator.dart';
import '../../domain/entities/transfer_job.dart';

class TransferProgressScreen extends StatelessWidget {
  const TransferProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer Progress')),
      body: StreamBuilder<List<TransferJobEntity>>(
        stream: TransferOrchestrator.instance.jobsStream,
        builder: (context, snapshot) {
          final jobs = snapshot.data ?? [];
          final activeJobs = jobs.where((j) => j.isActive).toList();
          final completedJobs = jobs.where((j) => j.isCompleted).toList();
          final failedJobs = jobs.where((j) => j.hasFailed).toList();
          final queuedJobs =
              jobs.where((j) => j.status == TransferStatus.queued).toList();

          if (jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64, color: AppColors.success.withAlpha(150)),
                  const SizedBox(height: 16),
                  Text('No active transfers',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('All transfers completed',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (activeJobs.isNotEmpty) _OverallProgressHeader(jobs: jobs),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    if (activeJobs.isNotEmpty) ...[
                      _SectionHeader(
                          title: 'Active',
                          count: activeJobs.length,
                          color: AppColors.primaryLight),
                      ...activeJobs
                          .map((j) => _TransferJobCard(key: ValueKey(j.id), job: j)),
                      const SizedBox(height: 16),
                    ],
                    if (queuedJobs.isNotEmpty) ...[
                      _SectionHeader(
                          title: 'Queued',
                          count: queuedJobs.length,
                          color: AppColors.textSecondary),
                      ...queuedJobs
                          .map((j) => _TransferJobCard(key: ValueKey(j.id), job: j)),
                      const SizedBox(height: 16),
                    ],
                    if (completedJobs.isNotEmpty) ...[
                      _SectionHeader(
                          title: 'Completed',
                          count: completedJobs.length,
                          color: AppColors.success),
                      ...completedJobs
                          .map((j) => _TransferJobCard(key: ValueKey(j.id), job: j)),
                      const SizedBox(height: 16),
                    ],
                    if (failedJobs.isNotEmpty) ...[
                      _SectionHeader(
                          title: 'Failed',
                          count: failedJobs.length,
                          color: AppColors.error),
                      ...failedJobs
                          .map((j) => _TransferJobCard(key: ValueKey(j.id), job: j)),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OverallProgressHeader extends StatelessWidget {
  const _OverallProgressHeader({required this.jobs});

  final List<TransferJobEntity> jobs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeJobs = jobs.where((j) => j.isActive).toList();
    final totalBytes = activeJobs.fold<int>(0, (s, j) => s + j.fileSize);
    final transferredBytes =
        activeJobs.fold<int>(0, (s, j) => s + j.bytesTransferred);
    final totalSpeed =
        activeJobs.fold<int>(0, (s, j) => s + j.speedBytesPerSec);
    final progress = totalBytes > 0 ? transferredBytes / totalBytes : 0.0;
    final percent = (progress * 100).toStringAsFixed(1);

    Duration? eta;
    if (totalSpeed > 0) {
      final remaining = totalBytes - transferredBytes;
      eta = Duration(seconds: remaining ~/ totalSpeed);
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withAlpha(25),
            AppColors.primaryLight.withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight.withAlpha(60)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.swap_vert,
                  color: AppColors.primaryLight, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${activeJobs.length} active transfer${activeJobs.length > 1 ? 's' : ''}',
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Text(
                '$percent%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.darkDivider,
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.primaryLight),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${FileSizeFormatter.format(transferredBytes)} / ${FileSizeFormatter.format(totalBytes)}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const Spacer(),
              if (totalSpeed > 0) ...[
                const Icon(Icons.speed, size: 14, color: AppColors.primaryLight),
                const SizedBox(width: 4),
                Text(
                  FileSizeFormatter.speed(totalSpeed),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (eta != null) ...[
                const SizedBox(width: 12),
                const Icon(Icons.timer_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(eta),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    return '${d.inSeconds}s';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            '$title ($count)',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _TransferJobCard extends StatelessWidget {
  const _TransferJobCard({super.key, required this.job});

  final TransferJobEntity job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSend = job.direction == TransferDirection.send;
    final accentColor =
        isSend ? AppColors.transferSend : AppColors.transferReceive;
    final percent = (job.progress * 100).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isSend ? Icons.upload : Icons.download,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.fileName.isNotEmpty ? job.fileName : 'File',
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${isSend ? 'Sending to' : 'Receiving from'} ${job.peerName.isNotEmpty ? job.peerName : 'peer'}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (job.isActive)
                  Text(
                    '$percent%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (job.isCompleted)
                  const Icon(Icons.check_circle, color: AppColors.success, size: 24),
                if (job.hasFailed)
                  const Icon(Icons.error, color: AppColors.error, size: 24),
              ],
            ),
            if (job.isActive) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: job.progress,
                  backgroundColor: AppColors.darkDivider,
                  valueColor: AlwaysStoppedAnimation(accentColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${FileSizeFormatter.format(job.bytesTransferred)} / '
                    '${FileSizeFormatter.format(job.fileSize)}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  if (job.speedBytesPerSec > 0) ...[
                    Icon(Icons.speed, size: 13, color: accentColor),
                    const SizedBox(width: 4),
                    Text(
                      job.speedFormatted,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (job.eta != null) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.timer_outlined,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(job.eta!),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ],
            if (job.isCompleted) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    FileSizeFormatter.format(job.fileSize),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  Text(
                    'Completed',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.success),
                  ),
                ],
              ),
            ],
            if (job.hasFailed && job.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                job.errorMessage!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.error),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    return '${d.inSeconds}s';
  }
}
