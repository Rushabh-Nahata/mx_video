import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/status_item.dart';
import '../providers/status_provider.dart';
import '../widgets/status_grid_tile.dart';
import 'status_viewer_screen.dart';

class StatusSaverScreen extends ConsumerStatefulWidget {
  const StatusSaverScreen({super.key});

  @override
  ConsumerState<StatusSaverScreen> createState() => _StatusSaverScreenState();
}

class _StatusSaverScreenState extends ConsumerState<StatusSaverScreen> {
  bool _permissionChecked = false;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.manageExternalStorage.status;
    if (status.isGranted) {
      setState(() {
        _permissionChecked = true;
        _permissionGranted = true;
      });
    } else {
      final result = await Permission.manageExternalStorage.request();
      setState(() {
        _permissionChecked = true;
        _permissionGranted = result.isGranted;
      });
      if (result.isGranted) {
        // Refresh statuses now that we have permission
        ref.invalidate(recentStatusesProvider);
        ref.invalidate(savedStatusesProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionChecked) {
      return Scaffold(
        appBar: AppBar(title: const Text('Status Saver')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_permissionGranted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Status Saver')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.folder_off_outlined, size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(80)),
                const SizedBox(height: 16),
                Text('Storage permission required',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'To access WhatsApp statuses, please grant "All files access" permission.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Settings'),
                  onPressed: () async {
                    await openAppSettings();
                    // Re-check after returning from settings
                    await _checkPermission();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Status Saver'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recent'),
              Tab(text: 'Saved'),
            ],
          ),
          actions: [
            // Filter menu
            PopupMenuButton<StatusFilterType>(
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter',
              onSelected: (filter) =>
                  ref.read(statusFilterProvider.notifier).set(filter),
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: StatusFilterType.all,
                  child: Text('All'),
                ),
                PopupMenuItem(
                  value: StatusFilterType.images,
                  child: Text('Images only'),
                ),
                PopupMenuItem(
                  value: StatusFilterType.videos,
                  child: Text('Videos only'),
                ),
              ],
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _RecentTab(),
            _SavedTab(),
          ],
        ),
      ),
    );
  }
}

// ── Recent statuses tab ─────────────────────────────────────────────────────

class _RecentTab extends ConsumerWidget {
  const _RecentTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusesAsync = ref.watch(recentStatusesProvider);
    final filter = ref.watch(statusFilterProvider);

    return statusesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
        message: e.toString(),
        onRetry: () => ref.read(recentStatusesProvider.notifier).refresh(),
      ),
      data: (statuses) {
        if (statuses.isEmpty) {
          return _EmptyView(
            icon: Icons.chat_outlined,
            title: 'No WhatsApp statuses found',
            subtitle:
                'View some WhatsApp statuses first,\nthen come back here to save them.',
            onRefresh: () =>
                ref.read(recentStatusesProvider.notifier).refresh(),
          );
        }

        final filtered = _applyFilter(statuses, filter);
        if (filtered.isEmpty) {
          return const Center(
            child: Text('No statuses match the filter'),
          );
        }

        final grouped = _groupByDate(filtered);

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(recentStatusesProvider.notifier).refresh(),
          child: _DateGroupedGrid(
            groups: grouped,
            itemBuilder: (item) => StatusGridTile(
              item: item,
              showSaveButton: true,
              onTap: () => _openViewer(context, ref, item),
              onSave: () =>
                  ref.read(recentStatusesProvider.notifier).saveStatus(item.path),
            ),
            onSaveAll: (paths) =>
                ref.read(recentStatusesProvider.notifier).saveAll(paths),
          ),
        );
      },
    );
  }

  void _openViewer(BuildContext context, WidgetRef ref, StatusItem item) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => StatusViewerScreen(
          item: item,
          onSave: () =>
              ref.read(recentStatusesProvider.notifier).saveStatus(item.path),
        ),
      ),
    );
  }
}

// ── Saved statuses tab ──────────────────────────────────────────────────────

class _SavedTab extends ConsumerWidget {
  const _SavedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusesAsync = ref.watch(savedStatusesProvider);
    final filter = ref.watch(statusFilterProvider);

    return statusesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
        message: e.toString(),
        onRetry: () => ref.read(savedStatusesProvider.notifier).refresh(),
      ),
      data: (statuses) {
        if (statuses.isEmpty) {
          return _EmptyView(
            icon: Icons.download_done_outlined,
            title: 'No saved statuses',
            subtitle: 'Statuses you save will appear here.',
            onRefresh: () =>
                ref.read(savedStatusesProvider.notifier).refresh(),
          );
        }

        final filtered = _applyFilter(statuses, filter);
        if (filtered.isEmpty) {
          return const Center(
            child: Text('No statuses match the filter'),
          );
        }

        final grouped = _groupByDate(filtered);

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(savedStatusesProvider.notifier).refresh(),
          child: _DateGroupedGrid(
            groups: grouped,
            itemBuilder: (item) => StatusGridTile(
              item: item,
              showSaveButton: false,
              onTap: () => _openViewer(context, item),
              onDelete: () => _confirmDelete(context, ref, item),
            ),
          ),
        );
      },
    );
  }

  void _openViewer(BuildContext context, StatusItem item) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => StatusViewerScreen(item: item),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    StatusItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete saved status?'),
        content: const Text('This will remove it from your saved statuses.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(savedStatusesProvider.notifier).deleteStatus(item.path);
    }
  }
}

// ── Helpers ─────────────────────────────────────────────────────────────────

List<StatusItem> _applyFilter(
    List<StatusItem> items, StatusFilterType filter) {
  switch (filter) {
    case StatusFilterType.all:
      return items;
    case StatusFilterType.images:
      return items.where((i) => i.isImage).toList();
    case StatusFilterType.videos:
      return items.where((i) => i.isVideo).toList();
  }
}

Map<String, List<StatusItem>> _groupByDate(List<StatusItem> items) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final groups = <String, List<StatusItem>>{};
  for (final item in items) {
    final date = DateTime(
      item.dateModified.year,
      item.dateModified.month,
      item.dateModified.day,
    );

    String label;
    if (date == today) {
      label = 'Today';
    } else if (date == yesterday) {
      label = 'Yesterday';
    } else {
      label =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    groups.putIfAbsent(label, () => []).add(item);
  }
  return groups;
}

// ── Date-grouped grid ───────────────────────────────────────────────────────

class _DateGroupedGrid extends StatelessWidget {
  const _DateGroupedGrid({
    required this.groups,
    required this.itemBuilder,
    this.onSaveAll,
  });

  final Map<String, List<StatusItem>> groups;
  final Widget Function(StatusItem) itemBuilder;
  final void Function(List<String> paths)? onSaveAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        for (final entry in groups.entries) ...[
          // Date header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    entry.key,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.value.length} item${entry.value.length == 1 ? '' : 's'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(120),
                    ),
                  ),
                  const Spacer(),
                  if (onSaveAll != null &&
                      entry.value.any((i) => !i.isSaved))
                    TextButton.icon(
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Save all'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => onSaveAll!(
                        entry.value
                            .where((i) => !i.isSaved)
                            .map((i) => i.path)
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Status grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => RepaintBoundary(
                  child: itemBuilder(entry.value[i]),
                ),
                childCount: entry.value.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
            ),
          ),
        ],

        // Bottom spacing
        const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
      ],
    );
  }
}

// ── Empty / Error views ─────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRefresh,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.onSurface.withAlpha(80)),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(120),
              ),
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                onPressed: onRefresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Could not load statuses',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
