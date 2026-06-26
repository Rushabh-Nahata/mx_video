import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../library/domain/entities/media_file.dart';
import '../../../library/presentation/providers/library_provider.dart';
import '../../../library/presentation/widgets/media_action_sheet.dart';
import '../../../library/presentation/widgets/media_grid_tile.dart';
import '../../../library/presentation/widgets/media_list_tile.dart';
import '../../../library/presentation/widgets/sort_bottom_sheet.dart';

class BrowserScreen extends ConsumerWidget {
  const BrowserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(sortedAllFilesProvider);
    final sortOrder = ref.watch(folderSortOrderProvider);
    final selection = ref.watch(selectionProvider);
    final isSelecting = selection.isNotEmpty;
    final viewColumns = ref.watch(mediaViewColumnsProvider);
    final isGridView = viewColumns > 1;

    return Scaffold(
      appBar: isSelecting
          ? _selectionAppBar(context, ref, selection, filesAsync)
          : AppBar(
              title: const Text('All Videos'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () => context.push(RouteNames.search),
                ),
                IconButton(
                  icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                  tooltip: isGridView ? 'List view' : 'Grid view',
                  onPressed: () {
                    ref
                        .read(mediaViewColumnsProvider.notifier)
                        .set(isGridView ? 1 : 2);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort',
                  onPressed: () async {
                    final result =
                        await SortBottomSheet.show(context, sortOrder);
                    if (result != null) {
                      ref.read(folderSortOrderProvider.notifier).set(result);
                    }
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter',
                  onSelected: (String value) =>
                      ref.read(_videoFilterProvider.notifier).set(value),
                  itemBuilder: (_) {
                    final current = ref.read(_videoFilterProvider);
                    return <PopupMenuEntry<String>>[
                      _filterItem('all', 'All Videos', current),
                      _filterItem('recent', 'Recently Played', current),
                      _filterItem('favourites', 'Favourites', current),
                      _filterItem('long', 'Long Videos (>20 min)', current),
                      _filterItem('short', 'Short Videos (<5 min)', current),
                      _filterItem('hd', 'HD & Above (720p+)', current),
                      _filterItem('large', 'Large Files (>500 MB)', current),
                    ];
                  },
                ),
              ],
            ),
      body: filesAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (allFiles) {
          final filter = ref.watch(_videoFilterProvider);
          final files = _applyFilter(allFiles, filter);

          if (files.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EmptyState(
                    icon: Icons.video_library_outlined,
                    title: 'No videos found',
                    subtitle: 'No videos match the current filter',
                  ),
                  if (filter != 'all') ...[
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () =>
                          ref.read(_videoFilterProvider.notifier).set('all'),
                      child: const Text('Clear Filter'),
                    ),
                  ],
                ],
              ),
            );
          }

          final videoPaths = files.map((f) => f.absolutePath).toList();

          return Column(
            children: [
              _StatsBar(files: files, filter: filter),
              Expanded(
                child: _buildContent(
                  context,
                  ref,
                  files: files,
                  videoPaths: videoPaths,
                  selection: selection,
                  isSelecting: isSelecting,
                  isGridView: isGridView,
                  viewColumns: viewColumns,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref, {
    required List<MediaFileEntity> files,
    required List<String> videoPaths,
    required Set<int> selection,
    required bool isSelecting,
    required bool isGridView,
    required int viewColumns,
  }) {
    void onFileTap(MediaFileEntity file) {
      if (isSelecting) {
        ref.read(selectionProvider.notifier).toggle(file.id);
        return;
      }
      final videoIndex = videoPaths.indexOf(file.absolutePath);
      context.push(
        '${RouteNames.videoPlayer}?path=${Uri.encodeComponent(file.absolutePath)}',
        extra: {
          'playlist': videoPaths,
          'startIndex': videoIndex >= 0 ? videoIndex : 0,
        },
      );
    }

    void onSelectItem(int fileId) {
      ref.read(selectionProvider.notifier).toggle(fileId);
    }

    void onDragSelectRange(Set<int> ids) {
      ref.read(selectionProvider.notifier).addAll(ids.toList());
    }

    if (isGridView) {
      return _PinchZoomGrid(
        columns: viewColumns,
        minColumns: 2,
        maxColumns: 4,
        onColumnsChanged: (c) =>
            ref.read(mediaViewColumnsProvider.notifier).set(c),
        child: _DragSelectGrid(
          files: files,
          selection: selection,
          isSelecting: isSelecting,
          viewColumns: viewColumns,
          onFileTap: onFileTap,
          onSelectItem: onSelectItem,
          onDragSelectRange: onDragSelectRange,
        ),
      );
    }

    return _DragSelectList(
      files: files,
      selection: selection,
      isSelecting: isSelecting,
      onFileTap: onFileTap,
      onSelectItem: onSelectItem,
      onDragSelectRange: onDragSelectRange,
    );
  }

  PopupMenuItem<String> _filterItem(
      String value, String label, String current) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            value == current ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: value == current ? AppColors.primaryLight : AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }

  List<MediaFileEntity> _applyFilter(
      List<MediaFileEntity> files, String filter) {
    return switch (filter) {
      'recent' => files.where((f) => f.hasBeenPlayed).toList(),
      'favourites' => files.where((f) => f.isFavourite).toList(),
      'long' =>
        files.where((f) => (f.durationMs ?? 0) > 20 * 60 * 1000).toList(),
      'short' =>
        files.where((f) => (f.durationMs ?? 0) < 5 * 60 * 1000 && (f.durationMs ?? 0) > 0).toList(),
      'hd' => files.where((f) => (f.height ?? 0) >= 720).toList(),
      'large' =>
        files.where((f) => f.sizeBytes > 500 * 1024 * 1024).toList(),
      _ => files,
    };
  }

  AppBar _selectionAppBar(
    BuildContext context,
    WidgetRef ref,
    Set<int> selection,
    AsyncValue<List<MediaFileEntity>> filesAsync,
  ) {
    final allFiles = filesAsync.asData?.value ?? [];
    final allSelected =
        allFiles.isNotEmpty && selection.length >= allFiles.length;

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => ref.read(selectionProvider.notifier).clear(),
      ),
      title: Text('${selection.length} selected'),
      actions: [
        IconButton(
          icon: Icon(allSelected
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank),
          tooltip: allSelected ? 'Deselect All' : 'Select All',
          onPressed: () {
            if (allSelected) {
              ref.read(selectionProvider.notifier).clear();
            } else {
              ref
                  .read(selectionProvider.notifier)
                  .selectAll(allFiles.map((f) => f.id).toList());
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.send_outlined),
          tooltip: 'Send via MX Video',
          onPressed: () async {
            final dao = ref.read(mediaDaoProvider);
            final files = await dao.getFilesByIds(selection.toList());
            if (context.mounted) {
              unawaited(context.push(
                RouteNames.peerList,
                extra: files.map((f) => f.absolutePath).toList(),
              ));
            }
            ref.read(selectionProvider.notifier).clear();
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: 'Share',
          onPressed: () async {
            final dao = ref.read(mediaDaoProvider);
            final files = await dao.getFilesByIds(selection.toList());
            await shareFiles(files.map((f) => f.absolutePath).toList());
            ref.read(selectionProvider.notifier).clear();
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete',
          onPressed: () async {
            final confirmed = await confirmDelete(context, selection.length);
            if (confirmed) {
              final dao = ref.read(mediaDaoProvider);
              final files = await dao.getFilesByIds(selection.toList());
              await deleteFilesFromDisk(
                  files.map((f) => f.absolutePath).toList());
              await dao.deleteFiles(selection.toList());
              ref.read(selectionProvider.notifier).clear();
            }
          },
        ),
      ],
    );
  }
}

// ── Filter state ──────────────────────────────────────────────────────────────

final _videoFilterProvider = NotifierProvider<_VideoFilterNotifier, String>(
  _VideoFilterNotifier.new,
);

class _VideoFilterNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void set(String filter) => state = filter;
}

// ── Stats bar ─────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.files, required this.filter});

  final List<MediaFileEntity> files;
  final String filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSize = files.fold<int>(0, (s, f) => s + f.sizeBytes);
    final totalDuration =
        files.fold<int>(0, (s, f) => s + (f.durationMs ?? 0));

    final filterLabel = switch (filter) {
      'recent' => 'Recently Played',
      'favourites' => 'Favourites',
      'long' => 'Long Videos',
      'short' => 'Short Videos',
      'hd' => 'HD & Above',
      'large' => 'Large Files',
      _ => null,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(30),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${files.length} videos',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '•',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(width: 6),
          Text(
            FileSizeFormatter.format(totalSize),
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          if (totalDuration > 0) ...[
            const SizedBox(width: 6),
            Text(
              '•',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              DurationFormatter.format(totalDuration),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
          const Spacer(),
          if (filterLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filterLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.filter_list,
                      size: 12, color: AppColors.primaryLight),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Drag-to-select list view ──────────────────────────────────────────────────

class _DragSelectList extends StatefulWidget {
  const _DragSelectList({
    required this.files,
    required this.selection,
    required this.isSelecting,
    required this.onFileTap,
    required this.onSelectItem,
    required this.onDragSelectRange,
  });

  final List<MediaFileEntity> files;
  final Set<int> selection;
  final bool isSelecting;
  final void Function(MediaFileEntity) onFileTap;
  final void Function(int fileId) onSelectItem;
  final void Function(Set<int> ids) onDragSelectRange;

  @override
  State<_DragSelectList> createState() => _DragSelectListState();
}

class _DragSelectListState extends State<_DragSelectList> {
  int? _dragStartIndex;
  int _dragCurrentIndex = -1;
  final _itemKeys = <int, GlobalKey>{};

  GlobalKey _keyFor(int index) =>
      _itemKeys.putIfAbsent(index, () => GlobalKey());

  int? _indexAtPosition(Offset globalPosition) {
    for (int i = 0; i < widget.files.length; i++) {
      final key = _itemKeys[i];
      if (key?.currentContext == null) continue;
      final box = key!.currentContext!.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      final pos = box.localToGlobal(Offset.zero);
      final size = box.size;
      if (globalPosition.dy >= pos.dy &&
          globalPosition.dy <= pos.dy + size.height) {
        return i;
      }
    }
    return null;
  }

  void _selectRange() {
    if (_dragStartIndex == null || _dragCurrentIndex < 0) return;
    final start = _dragStartIndex! < _dragCurrentIndex
        ? _dragStartIndex!
        : _dragCurrentIndex;
    final end = _dragStartIndex! > _dragCurrentIndex
        ? _dragStartIndex!
        : _dragCurrentIndex;
    final ids = <int>{};
    for (int i = start; i <= end; i++) {
      ids.add(widget.files[i].id);
    }
    widget.onDragSelectRange(ids);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        final index = _indexAtPosition(details.globalPosition);
        if (index != null) {
          setState(() {
            _dragStartIndex = index;
            _dragCurrentIndex = index;
          });
          widget.onSelectItem(widget.files[index].id);
        }
      },
      onLongPressMoveUpdate: (details) {
        if (_dragStartIndex == null) return;
        final index = _indexAtPosition(details.globalPosition);
        if (index != null && index != _dragCurrentIndex) {
          setState(() => _dragCurrentIndex = index);
          _selectRange();
        }
      },
      onLongPressEnd: (_) {
        if (_dragStartIndex != null) {
          _selectRange();
          setState(() {
            _dragStartIndex = null;
            _dragCurrentIndex = -1;
          });
        }
      },
      child: ListView.builder(
        itemCount: widget.files.length,
        itemBuilder: (context, i) {
          final file = widget.files[i];
          final selected = widget.selection.contains(file.id);

          return RepaintBoundary(
            key: _keyFor(i),
            child: _SelectableListTile(
              file: file,
              isSelecting: widget.isSelecting,
              isSelected: selected,
              onTap: () => widget.onFileTap(file),
            ),
          );
        },
      ),
    );
  }
}

// ── Drag-to-select grid view ──────────────────────────────────────────────────

class _DragSelectGrid extends StatefulWidget {
  const _DragSelectGrid({
    required this.files,
    required this.selection,
    required this.isSelecting,
    required this.viewColumns,
    required this.onFileTap,
    required this.onSelectItem,
    required this.onDragSelectRange,
  });

  final List<MediaFileEntity> files;
  final Set<int> selection;
  final bool isSelecting;
  final int viewColumns;
  final void Function(MediaFileEntity) onFileTap;
  final void Function(int fileId) onSelectItem;
  final void Function(Set<int> ids) onDragSelectRange;

  @override
  State<_DragSelectGrid> createState() => _DragSelectGridState();
}

class _DragSelectGridState extends State<_DragSelectGrid> {
  int? _dragStartIndex;
  int _dragCurrentIndex = -1;
  final _itemKeys = <int, GlobalKey>{};

  GlobalKey _keyFor(int index) =>
      _itemKeys.putIfAbsent(index, () => GlobalKey());

  int? _indexAtPosition(Offset globalPosition) {
    for (int i = 0; i < widget.files.length; i++) {
      final key = _itemKeys[i];
      if (key?.currentContext == null) continue;
      final box = key!.currentContext!.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      final pos = box.localToGlobal(Offset.zero);
      final size = box.size;
      if (globalPosition.dy >= pos.dy &&
          globalPosition.dy <= pos.dy + size.height &&
          globalPosition.dx >= pos.dx &&
          globalPosition.dx <= pos.dx + size.width) {
        return i;
      }
    }
    return null;
  }

  void _selectRange() {
    if (_dragStartIndex == null || _dragCurrentIndex < 0) return;
    final start = _dragStartIndex! < _dragCurrentIndex
        ? _dragStartIndex!
        : _dragCurrentIndex;
    final end = _dragStartIndex! > _dragCurrentIndex
        ? _dragStartIndex!
        : _dragCurrentIndex;
    final ids = <int>{};
    for (int i = start; i <= end; i++) {
      ids.add(widget.files[i].id);
    }
    widget.onDragSelectRange(ids);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        final index = _indexAtPosition(details.globalPosition);
        if (index != null) {
          setState(() {
            _dragStartIndex = index;
            _dragCurrentIndex = index;
          });
          widget.onSelectItem(widget.files[index].id);
        }
      },
      onLongPressMoveUpdate: (details) {
        if (_dragStartIndex == null) return;
        final index = _indexAtPosition(details.globalPosition);
        if (index != null && index != _dragCurrentIndex) {
          setState(() => _dragCurrentIndex = index);
          _selectRange();
        }
      },
      onLongPressEnd: (_) {
        if (_dragStartIndex != null) {
          _selectRange();
          setState(() {
            _dragStartIndex = null;
            _dragCurrentIndex = -1;
          });
        }
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.viewColumns,
          childAspectRatio: 1.0,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemCount: widget.files.length,
        itemBuilder: (context, i) {
          final file = widget.files[i];
          final selected = widget.selection.contains(file.id);
          return RepaintBoundary(
            key: _keyFor(i),
            child: MediaGridTile(
              file: file,
              isSelecting: widget.isSelecting,
              isSelected: selected,
              onTap: () => widget.onFileTap(file),
            ),
          );
        },
      ),
    );
  }
}

// ── Pinch-to-zoom wrapper ───────────────────────────────────────────────────

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
          widget.onColumnsChanged(widget.columns - 1);
          _startScale = scale;
        } else if (scale < _startScale && widget.columns < widget.maxColumns) {
          widget.onColumnsChanged(widget.columns + 1);
          _startScale = scale;
        }
      },
      child: widget.child,
    );
  }
}

// ── Selectable list tile ────────────────────────────────────────────────────

class _SelectableListTile extends StatelessWidget {
  const _SelectableListTile({
    required this.file,
    required this.isSelecting,
    required this.isSelected,
    required this.onTap,
  });

  final MediaFileEntity file;
  final bool isSelecting;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MediaListTile(
          file: file,
          onTap: onTap,
        ),
        if (isSelecting)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withAlpha(200),
              ),
              padding: const EdgeInsets.all(2),
              child: Icon(
                isSelected ? Icons.check : Icons.circle_outlined,
                size: 18,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ),
      ],
    );
  }
}
