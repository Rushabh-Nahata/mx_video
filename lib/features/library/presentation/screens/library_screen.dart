import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/utils/permission_helper.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/thumbnail_widget.dart';
import '../../domain/entities/media_file.dart';
import '../../domain/entities/scan_state.dart';
import '../providers/library_provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/folder_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);
    final recentsAsync = ref.watch(recentsProvider);
    final scanState = ref.watch(scanProvider);

    // Trigger background thumbnail pre-loading.
    ref.watch(thumbnailPreloaderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(RouteNames.search),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'favourites':
                  context.push(RouteNames.favourites);
                case 'storage':
                  context.push(RouteNames.storage);
                case 'status_saver':
                  context.push(RouteNames.statusSaver);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'favourites', child: Text('Favourites')),
              PopupMenuItem(value: 'status_saver', child: Text('WhatsApp Status Saver')),
              PopupMenuItem(value: 'storage', child: Text('Storage Info')),
            ],
          ),
        ],
      ),
      body: foldersAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (folders) {
          if (folders.isEmpty && !scanState.isRunning) {
            // Permission was denied — show a dedicated prompt.
            if (scanState.phase == ScanPhase.error &&
                scanState.errorMessage != null &&
                scanState.errorMessage!.contains('permission')) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.folder_off_outlined, size: 64,
                          color: Colors.white38),
                      const SizedBox(height: 16),
                      Text('Storage Permission Required',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        'MX Video needs access to your media files to display videos and audio.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white60,
                            ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Grant Permission'),
                        onPressed: () =>
                            ref.read(scanProvider.notifier).startScan(),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => PermissionHelper.openSettings(),
                        child: const Text('Open App Settings'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return EmptyState(
              icon: Icons.video_library_outlined,
              title: 'No videos found',
              subtitle: 'Tap Scan to index your device storage',
              action: FilledButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Scan device'),
                onPressed: () =>
                    ref.read(scanProvider.notifier).startScan(),
              ),
            );
          }

          final crossAxisCount = ref.watch(folderGridColumnsProvider);

          return _PinchZoomGrid(
            columns: crossAxisCount,
            minColumns: 2,
            maxColumns: 5,
            onColumnsChanged: (c) =>
                ref.read(folderGridColumnsProvider.notifier).set(c),
            child: CustomScrollView(
              slivers: [
                // ── Recently Played ──────────────────────────────────────
                recentsAsync.when(
                  loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  data: (recents) {
                    if (recents.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                    return SliverToBoxAdapter(
                      child: _RecentsSection(recents: recents),
                    );
                  },
                ),

                // ── Folders header ───────────────────────────────────────
                if (folders.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Folders',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(153),
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),

                // ── Folder grid ──────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => RepaintBoundary(
                        child: FolderCard(
                          folder: folders[i],
                          onTap: () => context.go(
                            '${RouteNames.folderDetail}?id=${folders[i].id}',
                          ),
                        ),
                      ),
                      childCount: folders.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.82,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: scanState.isRunning
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.refresh),
              label: const Text('Scan'),
              onPressed: () =>
                  ref.read(scanProvider.notifier).startScan(),
            ),
    );
  }
}

// ── Recently Played horizontal strip ─────────────────────────────────────────

class _RecentsSection extends StatelessWidget {
  const _RecentsSection({required this.recents});
  final List<MediaFileEntity> recents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayList = recents.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                'Recently Played',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(153),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => GoRouter.of(context).push(RouteNames.recents),
                child: const Text('See all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 128,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: displayList.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final file = displayList[i];
              return RepaintBoundary(
                child: _RecentCard(
                  file: file,
                  onTap: () {
                    final route =
                        file.isVideo ? RouteNames.videoPlayer : RouteNames.audioPlayer;
                    context.push(
                      '$route?path=${Uri.encodeComponent(file.absolutePath)}',
                    );
                  },
                ),
              );
            },
          ),
        ),
        Divider(
          height: 24,
          indent: 16,
          endIndent: 16,
          color: theme.colorScheme.outlineVariant.withAlpha(80),
        ),
      ],
    );
  }
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({required this.file, required this.onTap});
  final MediaFileEntity file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = file.durationMs != null && file.durationMs! > 0
        ? (file.playPositionMs / file.durationMs!).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  ThumbnailWidget(
                    path: file.thumbnailPath,
                    videoPath: file.isVideo && file.thumbnailPath == null
                        ? file.absolutePath
                        : null,
                    width: 160,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                  // Progress bar at bottom of thumbnail
                  if (progress > 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 3,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              file.name,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Scan progress banner ──────────────────────────────────────────────────────

// ── Pinch-to-zoom wrapper ─────────────────────────────────────────────────────

class _PinchZoomGrid extends StatefulWidget {
  const _PinchZoomGrid({
    required this.columns,
    required this.minColumns,
    required this.maxColumns,
    required this.onColumnsChanged,
    required this.child,
  });

  final int columns;
  final int minColumns;
  final int maxColumns;
  final ValueChanged<int> onColumnsChanged;
  final Widget child;

  @override
  State<_PinchZoomGrid> createState() => _PinchZoomGridState();
}

class _PinchZoomGridState extends State<_PinchZoomGrid> {
  double _startScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) => _startScale = 1.0,
      onScaleUpdate: (details) {
        final scale = details.scale;
        if ((scale - _startScale).abs() < 0.3) return;

        if (scale > _startScale && widget.columns > widget.minColumns) {
          // Pinch out (zoom in) → fewer columns = bigger tiles
          widget.onColumnsChanged(widget.columns - 1);
          _startScale = scale;
        } else if (scale < _startScale && widget.columns < widget.maxColumns) {
          // Pinch in (zoom out) → more columns = smaller tiles
          widget.onColumnsChanged(widget.columns + 1);
          _startScale = scale;
        }
      },
      child: widget.child,
    );
  }
}

