import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/peer_device.dart';

class PeerCard extends StatelessWidget {
  const PeerCard({
    super.key,
    required this.peer,
    this.onSend,
  });

  final PeerDevice peer;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(30),
          child: Icon(
            _platformIcon(peer.platform),
            color: AppColors.primaryLight,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                peer.name,
                style: theme.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _ConnectionBadge(method: peer.connectionMethod),
          ],
        ),
        subtitle: peer.ipAddress.isNotEmpty
            ? Text(
                peer.ipAddress,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : Text(
                peer.connectionMethod == ConnectionMethod.bluetooth
                    ? 'Not on same WiFi — cannot transfer'
                    : _connectionMethodLabel(peer.connectionMethod),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: peer.connectionMethod == ConnectionMethod.bluetooth
                      ? AppColors.warning
                      : AppColors.textSecondary,
                ),
              ),
        trailing: onSend != null
            ? FilledButton.icon(
                icon: Icon(
                  peer.ipAddress.isEmpty ? Icons.wifi_off : Icons.send,
                  size: 16,
                ),
                label: Text(peer.ipAddress.isEmpty ? 'No WiFi' : 'Send'),
                onPressed: onSend,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: peer.ipAddress.isEmpty
                      ? AppColors.textSecondary
                      : null,
                ),
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  IconData _platformIcon(PeerPlatform platform) => switch (platform) {
        PeerPlatform.ios => Icons.phone_iphone,
        PeerPlatform.android => Icons.phone_android,
        PeerPlatform.windows => Icons.desktop_windows,
        PeerPlatform.macos => Icons.laptop_mac,
        PeerPlatform.linux => Icons.computer,
        PeerPlatform.unknown => Icons.devices,
      };

  String _connectionMethodLabel(ConnectionMethod method) => switch (method) {
        ConnectionMethod.wifi => 'WiFi',
        ConnectionMethod.bluetooth => 'Bluetooth',
        ConnectionMethod.qrCode => 'QR Code',
        ConnectionMethod.wifiDirect => 'WiFi Direct',
        ConnectionMethod.hotspot => 'Hotspot',
      };
}

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
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
