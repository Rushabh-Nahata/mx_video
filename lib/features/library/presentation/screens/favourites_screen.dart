import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../providers/library_provider.dart';
import '../widgets/media_list_tile.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favsAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (files) {
          if (files.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border,
              title: 'No favourites yet',
              subtitle: 'Long press a video and tap the heart to add it here',
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
