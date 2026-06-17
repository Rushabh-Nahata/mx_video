import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_provider.dart';
import '../widgets/peer_card.dart';

/// Standalone screen shown when the user wants to pick a peer to send to.
/// Receives [filePaths] as the files to send.
class PeerListScreen extends ConsumerWidget {
  const PeerListScreen({super.key, required this.filePaths});

  final List<String> filePaths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peersAsync = ref.watch(peersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Send ${filePaths.length} file${filePaths.length > 1 ? 's' : ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR Code',
            onPressed: () async {
              final peer = await context.push(RouteNames.qrScan);
              if (peer != null && context.mounted) {
                // Send files to the QR-connected peer.
                await ref
                    .read(transferManagerProvider.notifier)
                    .sendFiles(peer as dynamic, filePaths);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: peersAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Looking for devices...'),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text('Error: $e', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        data: (peers) {
          if (peers.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.devices_other_outlined,
                      size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No devices found',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Try scanning a QR code instead',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR Code'),
                    onPressed: () => context.push(RouteNames.qrScan),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: peers.length,
            itemBuilder: (context, i) => PeerCard(
              peer: peers[i],
              onSend: () async {
                await ref
                    .read(transferManagerProvider.notifier)
                    .sendFiles(peers[i], filePaths);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}
