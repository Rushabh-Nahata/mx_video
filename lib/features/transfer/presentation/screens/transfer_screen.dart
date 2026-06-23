import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/transfer_orchestrator.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../domain/entities/peer_device.dart';
import '../providers/transfer_provider.dart';
import '../widgets/connection_method_sheet.dart';
import '../widgets/peer_card.dart';
import '../widgets/transfer_progress_card.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    // Start server and advertising when transfer screen becomes active.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transferManagerProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Nearby Devices'),
            Tab(text: 'History'),
          ],
        ),
        actions: [
          // mDNS radar discovery screen.
          IconButton(
            icon: const Icon(Icons.wifi_tethering),
            tooltip: 'Discover Devices',
            onPressed: () => _openDiscovery(context),
          ),
          // QR code display button.
          IconButton(
            icon: const Icon(Icons.qr_code),
            tooltip: 'Show QR Code',
            onPressed: () => context.push(RouteNames.qrDisplay),
          ),
          // QR code scan button.
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR Code',
            onPressed: () => context.push(RouteNames.qrScan),
          ),
          // Connection method selector.
          IconButton(
            icon: const Icon(Icons.settings_input_antenna),
            tooltip: 'Connection Methods',
            onPressed: () => _showConnectionMethodSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Active transfer banner (shows aggregate progress).
          _ActiveTransferBanner(),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _NearbyTab(),
                _HistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDiscovery(BuildContext context) async {
    final device = await context.push<PeerDevice>(RouteNames.discovery);
    if (!context.mounted || device == null) return;
    // Pick files first, then navigate to peer list with them.
    final filePaths = await _pickFiles();
    if (filePaths == null || filePaths.isEmpty) return;
    if (!context.mounted) return;
    await context.push(RouteNames.peerList, extra: filePaths);
  }

  Future<List<String>?> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result == null) return null;
    return result.paths.whereType<String>().toList();
  }

  void _showConnectionMethodSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const ConnectionMethodSheet(),
    );
  }
}

// ── Active Transfer Banner ─────────────────────────────────────────────────

class _ActiveTransferBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: TransferOrchestrator.instance.jobsStream,
      builder: (context, snapshot) {
        final orch = TransferOrchestrator.instance;
        if (orch.activeCount == 0) return const SizedBox.shrink();

        final theme = Theme.of(context);

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryLight.withAlpha(60)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.swap_vert,
                      color: AppColors.primaryLight, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${orch.activeCount} active transfer${orch.activeCount > 1 ? 's' : ''}',
                    style: theme.textTheme.titleSmall,
                  ),
                  const Spacer(),
                  if (orch.aggregateSpeed > 0)
                    Text(
                      _formatSpeed(orch.aggregateSpeed),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: orch.overallProgress,
                  backgroundColor: AppColors.darkDivider,
                  valueColor: const AlwaysStoppedAnimation(
                      AppColors.primaryLight),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatSpeed(int bytesPerSec) {
    if (bytesPerSec >= 1024 * 1024) {
      return '${(bytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
    if (bytesPerSec >= 1024) {
      return '${(bytesPerSec / 1024).toStringAsFixed(0)} KB/s';
    }
    return '$bytesPerSec B/s';
  }
}

// ── Nearby Tab ─────────────────────────────────────────────────────────────

class _NearbyTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peersAsync = ref.watch(peersProvider);

    return peersAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Scanning for devices...'),
          ],
        ),
      ),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Discovery error: $e'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR Code Instead'),
              onPressed: () => context.push(RouteNames.qrScan),
            ),
          ],
        ),
      ),
      data: (peers) {
        if (peers.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const EmptyState(
                  icon: Icons.devices_other_outlined,
                  title: 'No devices found',
                  subtitle:
                      'Make sure both devices are on the same WiFi or use QR code pairing',
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.wifi_tethering),
                  label: const Text('Discover Devices'),
                  onPressed: () => context.push(RouteNames.discovery),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.qr_code),
                      label: const Text('Show QR'),
                      onPressed: () => context.push(RouteNames.qrDisplay),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan QR'),
                      onPressed: () => context.push(RouteNames.qrScan),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(peersProvider),
          child: Column(
            children: [
              // Connection requirements info banner.
              const _ConnectionInfoBanner(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: peers.length,
                  itemBuilder: (context, i) => PeerCard(
                    peer: peers[i],
                    onSend: () => _onSendToPeer(context, ref, peers[i]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onSendToPeer(
      BuildContext context, WidgetRef ref, PeerDevice peer) async {
    // Check if BLE-only peer without IP — can't transfer.
    if (peer.ipAddress.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This device was found via Bluetooth but is not on the same '
            'WiFi network. Connect both devices to the same WiFi to transfer files.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    // Pick files to send.
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result == null || result.paths.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No files selected')),
        );
      }
      return;
    }

    final filePaths = result.paths.whereType<String>().toList();
    if (filePaths.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No accessible files selected')),
        );
      }
      return;
    }

    if (!context.mounted) return;

    // Show sending indicator.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sending ${filePaths.length} file${filePaths.length > 1 ? 's' : ''} '
          'to ${peer.name}...',
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await ref
          .read(transferManagerProvider.notifier)
          .sendFiles(peer, filePaths);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transfer to ${peer.name} started! Check History tab for progress.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      final message = _userFriendlyError(e.toString(), peer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  String _userFriendlyError(String error, PeerDevice peer) {
    final lower = error.toLowerCase();
    if (lower.contains('connection refused') ||
        lower.contains('connection timed out') ||
        lower.contains('host unreachable') ||
        lower.contains('no route to host') ||
        lower.contains('socketexception')) {
      return 'Cannot reach ${peer.name}. Make sure both devices are '
          'connected to the same WiFi network and the app is open on '
          'the other device.';
    }
    if (lower.contains('not accessible') || lower.contains('permission')) {
      return 'Cannot access the selected files. Please check file permissions.';
    }
    if (lower.contains('rejected')) {
      return 'Transfer was rejected by ${peer.name}.';
    }
    return 'Transfer failed: $error';
  }
}

// ── Connection Info Banner ──────────────────────────────────────────────────

class _ConnectionInfoBanner extends StatelessWidget {
  const _ConnectionInfoBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.info.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.info.withAlpha(40)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Both devices must be on the same WiFi network to transfer files. '
              'Bluetooth is used for discovery only.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── History Tab ────────────────────────────────────────────────────────────

class _HistoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(transferJobsProvider);

    return jobsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (jobs) {
        if (jobs.isEmpty) {
          return const EmptyState(
            icon: Icons.swap_horiz_outlined,
            title: 'No transfers yet',
            subtitle: 'Files you send or receive will appear here',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: jobs.length,
          itemBuilder: (context, i) => TransferProgressCard(job: jobs[i]),
        );
      },
    );
  }
}
