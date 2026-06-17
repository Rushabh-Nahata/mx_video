import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/entities/folder_node.dart';
import '../providers/browser_provider.dart';
import '../widgets/breadcrumb_bar.dart';
import '../widgets/file_tile.dart';

class BrowserScreen extends ConsumerWidget {
  const BrowserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(browserProvider);
    final notifier = ref.read(browserProvider.notifier);

    return PopScope(
      canPop: !state.canGoBack,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) notifier.goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Browse'),
          leading: state.canGoBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: notifier.goBack,
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: open search bar
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: BreadcrumbBar(
              pathStack: state.pathStack,
              onSegmentTap: (path) => notifier.navigateTo(path, clearStack: false),
            ),
          ),
        ),
        body: state.isLoading
            ? const LoadingShimmer()
            : state.entries.isEmpty
                ? const EmptyState(
                    icon: Icons.folder_open_outlined,
                    title: 'Folder is empty',
                    subtitle: 'No media files found here',
                  )
                : ListView.builder(
                    itemCount: state.entries.length,
                    itemBuilder: (context, i) {
                      final entry = state.entries[i];
                      if (entry is FolderNode) {
                        return FileTile.folder(
                          node: entry,
                          onTap: () => notifier.navigateTo(entry.path),
                        );
                      }
                      if (entry is FileNode) {
                        return FileTile.file(
                          node: entry,
                          onTap: () {
                            if (!entry.isMedia) return;
                            final route = entry.isVideo
                                ? RouteNames.videoPlayer
                                : RouteNames.audioPlayer;
                            context.push(
                              '$route?path=${Uri.encodeComponent(entry.path)}',
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
      ),
    );
  }
}
