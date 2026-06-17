import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../providers/library_provider.dart';
import '../widgets/media_list_tile.dart';

class RecentsScreen extends ConsumerWidget {
  const RecentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentsAsync = ref.watch(recentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recently Played')),
      body: recentsAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (files) {
          if (files.isEmpty) {
            return const EmptyState(
              icon: Icons.history,
              title: 'Nothing played yet',
              subtitle: 'Videos you watch will appear here',
            );
          }
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, i) => MediaListTile(
              file: files[i],
              onTap: () {
                final route = files[i].isVideo
                    ? RouteNames.videoPlayer
                    : RouteNames.audioPlayer;
                context.push(
                  '$route?path=${Uri.encodeComponent(files[i].absolutePath)}',
                );
              },
            ),
          );
        },
      ),
    );
  }
}
