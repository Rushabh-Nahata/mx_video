import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../domain/entities/app_settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // ── Appearance ─────────────────────────────────────────────────
            const _SectionHeader(label: 'Appearance'),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme throughout the app'),
              value: settings.themeMode == 'dark',
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).toggle();
                ref.read(settingsProvider.notifier).save(
                      settings.copyWith(themeMode: v ? 'dark' : 'light'),
                    );
              },
            ),

            // ── Playback ───────────────────────────────────────────────────
            const _SectionHeader(label: 'Playback'),
            SwitchListTile(
              secondary: const Icon(Icons.history),
              title: const Text('Resume from last position'),
              subtitle: const Text('Continue where you left off'),
              value: settings.resumeFromLastPosition,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(resumeFromLastPosition: v)),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.swipe_outlined),
              title: const Text('Gesture controls'),
              subtitle:
                  const Text('Swipe to adjust brightness and volume in player'),
              value: settings.useGestureControls,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(useGestureControls: v)),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.brightness_high_outlined),
              title: const Text('Keep screen on'),
              subtitle: const Text('Prevent screen from dimming during playback'),
              value: settings.keepScreenOn,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .save(settings.copyWith(keepScreenOn: v)),
            ),
            ListTile(
              leading: const Icon(Icons.speed_outlined),
              title: const Text('Default playback speed'),
              trailing: Text(
                settings.defaultPlaybackSpeed == 1.0
                    ? '1×'
                    : '${settings.defaultPlaybackSpeed}×',
                style: theme.textTheme.bodyMedium,
              ),
              onTap: () => _showSpeedPicker(context, ref, settings),
            ),

            // ── Library ────────────────────────────────────────────────────
            const _SectionHeader(label: 'Library'),
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: const Text('Scan folders'),
              subtitle: Text(
                settings.scanRootPaths.isEmpty
                    ? 'No folders selected'
                    : settings.scanRootPaths.join(', '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: navigate to scan path manager
              },
            ),

            // ── About ──────────────────────────────────────────────────────
            const _SectionHeader(label: 'About'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('MX Video'),
              subtitle: const Text('Version 1.0.0'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeedPicker(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    const speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Default Playback Speed',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: speeds.map((speed) {
                    final isSelected = settings.defaultPlaybackSpeed == speed;
                    return ListTile(
                      title: Text(
                        speed == 1.0 ? 'Normal (1×)' : '${speed}×',
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: theme.colorScheme.primary)
                          : null,
                      onTap: () {
                        ref.read(settingsProvider.notifier).save(
                              settings.copyWith(defaultPlaybackSpeed: speed),
                            );
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
