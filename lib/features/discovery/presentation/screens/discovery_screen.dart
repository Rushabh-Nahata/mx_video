import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../transfer/domain/entities/peer_device.dart';
import '../../domain/entities/discovery_state.dart';
import '../providers/discovery_provider.dart';
import '../widgets/device_tile.dart';
import '../widgets/scanning_indicator.dart';

/// Standalone screen that discovers nearby MX Video devices via mDNS.
///
/// Features:
/// - Continuous mDNS scanning with auto-refresh every 30 s
/// - Pull-to-refresh for manual rescan
/// - Animated radar indicator while scanning
/// - Callback [onDeviceSelected] when a peer is tapped
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key, this.onDeviceSelected});

  final ValueChanged<PeerDevice>? onDeviceSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discovery = ref.watch(deviceDiscoveryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Devices'),
        actions: [
          // Scanning spinner or manual refresh button.
          if (discovery.isScanning)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Rescan',
              onPressed: () =>
                  ref.read(deviceDiscoveryProvider.notifier).refresh(),
            ),
        ],
      ),
      body: _Body(
        state: discovery,
        onDeviceSelected: onDeviceSelected,
        onRefresh: () =>
            ref.read(deviceDiscoveryProvider.notifier).refresh(),
      ),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.onDeviceSelected,
    required this.onRefresh,
  });

  final DiscoveryState state;
  final ValueChanged<PeerDevice>? onDeviceSelected;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    // Error state.
    if (state.hasError && !state.hasDevices) {
      return _ErrorView(error: state.error!, onRetry: onRefresh);
    }

    // Initial scan with no results yet.
    if (state.isScanning && !state.hasDevices) {
      return const _ScanningView();
    }

    // No devices found after scan completed.
    if (!state.hasDevices) {
      return _EmptyView(onRefresh: onRefresh);
    }

    // Devices found.
    return _DeviceList(
      devices: state.devices,
      lastRefreshed: state.lastRefreshed,
      onDeviceSelected: onDeviceSelected,
      onRefresh: onRefresh,
    );
  }
}

// ── Scanning View ────────────────────────────────────────────────────────────

class _ScanningView extends StatelessWidget {
  const _ScanningView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ScanningIndicator(),
          const SizedBox(height: 24),
          Text(
            'Scanning for devices...',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure both devices are on the same WiFi network',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Empty View ───────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EmptyState(
            icon: Icons.devices_other_outlined,
            title: 'No devices found',
            subtitle:
                'Ensure both devices are running MX Video\nand connected to the same WiFi network',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Scan Again'),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}

// ── Error View ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              'Discovery failed',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Device List ──────────────────────────────────────────────────────────────

class _DeviceList extends StatelessWidget {
  const _DeviceList({
    required this.devices,
    required this.lastRefreshed,
    required this.onDeviceSelected,
    required this.onRefresh,
  });

  final List<PeerDevice> devices;
  final DateTime? lastRefreshed;
  final ValueChanged<PeerDevice>? onDeviceSelected;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: Column(
        children: [
          // Header with device count and last-refreshed time.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${devices.length} device${devices.length != 1 ? 's' : ''} found',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (lastRefreshed != null)
                  Text(
                    _formatTime(lastRefreshed!),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // Device list.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              itemCount: devices.length,
              itemBuilder: (context, i) => DeviceTile(
                device: devices[i],
                onTap: onDeviceSelected != null
                    ? () => onDeviceSelected!(devices[i])
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return 'Updated $h:$m:$s';
  }
}
