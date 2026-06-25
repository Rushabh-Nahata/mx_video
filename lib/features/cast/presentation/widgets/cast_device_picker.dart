import 'package:dart_cast/dart_cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cast_service.dart';
import '../providers/cast_provider.dart';

/// Bottom sheet that discovers and lists available cast devices.
class CastDevicePicker extends ConsumerStatefulWidget {
  const CastDevicePicker({super.key});

  static Future<CastDevice?> show(BuildContext context) {
    return showModalBottomSheet<CastDevice>(
      context: context,
      builder: (_) => const CastDevicePicker(),
    );
  }

  @override
  ConsumerState<CastDevicePicker> createState() => _CastDevicePickerState();
}

class _CastDevicePickerState extends ConsumerState<CastDevicePicker> {
  @override
  void initState() {
    super.initState();
    // Start discovery when sheet opens
    Future.microtask(() {
      ref.read(castDiscoveryProvider.notifier).startDiscovery();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  IconData _iconForProtocol(CastProtocol protocol) {
    switch (protocol) {
      case CastProtocol.chromecast:
        return Icons.cast;
      case CastProtocol.airplay:
        return Icons.airplay;
      case CastProtocol.dlna:
        return Icons.tv;
    }
  }

  String _labelForProtocol(CastProtocol protocol) {
    switch (protocol) {
      case CastProtocol.chromecast:
        return 'Chromecast';
      case CastProtocol.airplay:
        return 'AirPlay';
      case CastProtocol.dlna:
        return 'Smart TV (DLNA)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(castDiscoveryProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.cast, size: 22),
                const SizedBox(width: 10),
                Text('Cast to device',
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                if (devices.isEmpty)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Device list
          if (devices.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.wifi_find, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Searching for devices...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Make sure your TV/Chromecast is on\nthe same WiFi network',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, i) {
                  final device = devices[i];
                  return ListTile(
                    leading: Icon(_iconForProtocol(device.protocol)),
                    title: Text(device.name),
                    subtitle: Text(_labelForProtocol(device.protocol)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ref.read(castDiscoveryProvider.notifier).stopDiscovery();
                      Navigator.pop(context, device);
                    },
                  );
                },
              ),
            ),

          // Disconnect button (if connected)
          if (AppCastService.instance.isConnected)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.cast_connected),
                  label: Text(
                    'Disconnect from ${AppCastService.instance.connectedDevice?.name ?? "device"}',
                  ),
                  onPressed: () async {
                    await AppCastService.instance.disconnect();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
