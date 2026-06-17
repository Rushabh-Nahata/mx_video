import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../transfer/domain/entities/peer_device.dart';

/// Displays a discovered peer device with platform icon and connection badge.
class DeviceTile extends StatelessWidget {
  const DeviceTile({
    super.key,
    required this.device,
    this.onTap,
  });

  final PeerDevice device;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Platform icon.
              _PlatformAvatar(platform: device.platform),

              const SizedBox(width: 14),

              // Device info.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            device.name,
                            style: theme.textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _ConnectionBadge(method: device.connectionMethod),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.ipAddress.isNotEmpty
                          ? device.ipAddress
                          : _platformLabel(device.platform),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Status dot — green = online.
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _platformLabel(PeerPlatform platform) => switch (platform) {
        PeerPlatform.android => 'Android',
        PeerPlatform.ios => 'iOS',
        PeerPlatform.windows => 'Windows',
        PeerPlatform.macos => 'macOS',
        PeerPlatform.linux => 'Linux',
        PeerPlatform.unknown => 'Unknown',
      };
}

// ── Platform Avatar ──────────────────────────────────────────────────────────

class _PlatformAvatar extends StatelessWidget {
  const _PlatformAvatar({required this.platform});
  final PeerPlatform platform;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withAlpha(30),
      child: Icon(
        _icon,
        color: AppColors.primaryLight,
        size: 22,
      ),
    );
  }

  IconData get _icon => switch (platform) {
        PeerPlatform.ios => Icons.phone_iphone,
        PeerPlatform.android => Icons.phone_android,
        PeerPlatform.windows => Icons.desktop_windows,
        PeerPlatform.macos => Icons.laptop_mac,
        PeerPlatform.linux => Icons.computer,
        PeerPlatform.unknown => Icons.devices,
      };
}

// ── Connection Badge ─────────────────────────────────────────────────────────

class _ConnectionBadge extends StatelessWidget {
  const _ConnectionBadge({required this.method});
  final ConnectionMethod method;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (method) {
      ConnectionMethod.wifi => (Icons.wifi, AppColors.success, 'WiFi'),
      ConnectionMethod.bluetooth =>
        (Icons.bluetooth, const Color(0xFF2196F3), 'BT'),
      ConnectionMethod.qrCode =>
        (Icons.qr_code, AppColors.primaryLight, 'QR'),
      ConnectionMethod.wifiDirect =>
        (Icons.wifi_tethering, AppColors.accent, 'P2P'),
      ConnectionMethod.hotspot =>
        (Icons.portable_wifi_off, AppColors.warning, 'Hotspot'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
