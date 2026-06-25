import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_provider.dart';

/// Bottom sheet showing available connection methods and their status.
class ConnectionMethodSheet extends ConsumerWidget {
  const ConnectionMethodSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connection Methods', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Available ways to connect to other devices',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // WiFi (mDNS).
          const _MethodTile(
            icon: Icons.wifi,
            title: 'WiFi (Same Network)',
            subtitle: 'Auto-discovers devices on the same WiFi network',
            status: 'Active',
            statusColor: AppColors.success,
          ),

          // Bluetooth.
          FutureBuilder<bool>(
            future: ref.read(bleDiscoverySourceProvider).isAvailable,
            builder: (context, snapshot) {
              final available = snapshot.data ?? false;
              return _MethodTile(
                icon: Icons.bluetooth,
                title: 'Bluetooth (BLE)',
                subtitle: 'Finds nearby devices via Bluetooth Low Energy',
                status: available ? 'Active' : 'Unavailable',
                statusColor: available ? AppColors.success : AppColors.textSecondary,
              );
            },
          ),

          // QR Code.
          const _MethodTile(
            icon: Icons.qr_code,
            title: 'QR Code',
            subtitle: 'Scan or show a QR code for instant pairing',
            status: 'Always Available',
            statusColor: AppColors.primaryLight,
          ),

          // WiFi Direct.
          const _MethodTile(
            icon: Icons.wifi_tethering,
            title: 'WiFi Direct',
            subtitle: 'Direct device-to-device connection (Android)',
            status: 'Android Only',
            statusColor: AppColors.warning,
          ),

          // Hotspot.
          const _MethodTile(
            icon: Icons.portable_wifi_off,
            title: 'Hotspot',
            subtitle: 'Create a hotspot on one device, join from the other',
            status: 'Manual Setup',
            statusColor: AppColors.textSecondary,
          ),

          const SizedBox(height: 16),

          // Speed tips.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryLight.withAlpha(40)),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates,
                    color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'For fastest transfers, use the same WiFi network '
                    'with 5 GHz band. WiFi Direct and Hotspot are '
                    'alternatives when no shared WiFi is available.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: statusColor.withAlpha(20),
            child: Icon(icon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 11,
                  color: statusColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
