import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/browser/presentation/screens/browser_screen.dart';
import '../../features/discovery/presentation/screens/discovery_screen.dart';
import '../../features/library/domain/entities/media_file.dart';
import '../../features/library/presentation/screens/favourites_screen.dart';
import '../../features/library/presentation/screens/folder_detail_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/library/presentation/screens/recents_screen.dart';
import '../../features/library/presentation/screens/search_screen.dart';
import '../../features/library/presentation/screens/storage_screen.dart';
import '../../features/library/presentation/screens/video_details_screen.dart';
import '../../features/player/presentation/screens/audio_player_screen.dart';
import '../../features/player/presentation/screens/video_player_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/status_saver/presentation/screens/status_saver_screen.dart';
import '../../features/shell/shell_screen.dart';
import '../../features/transfer/presentation/screens/peer_list_screen.dart';
import '../../features/transfer/presentation/screens/qr_display_screen.dart';
import '../../features/transfer/presentation/screens/qr_scan_screen.dart';
import '../../features/transfer/presentation/screens/transfer_screen.dart';
import '../constants/route_names.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.library,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.library,
            builder: (context, state) => const LibraryScreen(),
            routes: [
              GoRoute(
                path: 'folder',
                builder: (context, state) {
                  final folderId = int.parse(
                    state.uri.queryParameters['id'] ?? '0',
                  );
                  return FolderDetailScreen(folderId: folderId);
                },
              ),
              GoRoute(
                path: 'recents',
                builder: (context, state) => const RecentsScreen(),
              ),
              GoRoute(
                path: 'favourites',
                builder: (context, state) => const FavouritesScreen(),
              ),
              GoRoute(
                path: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
              GoRoute(
                path: 'details',
                builder: (context, state) {
                  final file = state.extra as MediaFileEntity;
                  return VideoDetailsScreen(file: file);
                },
              ),
              GoRoute(
                path: 'storage',
                builder: (context, state) => const StorageScreen(),
              ),
              GoRoute(
                path: 'status-saver',
                builder: (context, state) => const StatusSaverScreen(),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.browser,
            builder: (context, state) => const BrowserScreen(),
          ),
          GoRoute(
            path: RouteNames.transfer,
            builder: (context, state) => const TransferScreen(),
          ),
          GoRoute(
            path: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // Full-screen routes (outside shell / bottom nav)
      GoRoute(
        path: RouteNames.videoPlayer,
        builder: (context, state) {
          final path = state.uri.queryParameters['path'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          final playlist = extra?['playlist'] as List<String>? ?? const [];
          final startIndex = extra?['startIndex'] as int? ?? 0;
          return VideoPlayerScreen(
            filePath: path,
            playlist: playlist,
            startIndex: startIndex,
          );
        },
      ),
      GoRoute(
        path: RouteNames.audioPlayer,
        builder: (context, state) {
          final path = state.uri.queryParameters['path'] ?? '';
          return AudioPlayerScreen(filePath: path);
        },
      ),

      // Transfer — Device discovery (mDNS radar screen)
      GoRoute(
        path: RouteNames.discovery,
        builder: (context, state) => DiscoveryScreen(
          onDeviceSelected: (device) => Navigator.of(context).pop(device),
        ),
      ),

      // Transfer — QR code routes
      GoRoute(
        path: RouteNames.qrDisplay,
        builder: (context, state) => const QrDisplayScreen(),
      ),
      GoRoute(
        path: RouteNames.qrScan,
        builder: (context, state) => const QrScanScreen(),
      ),

      // Transfer — Peer list (for sending files)
      GoRoute(
        path: RouteNames.peerList,
        builder: (context, state) {
          final filePaths =
              state.extra as List<String>? ?? [];
          return PeerListScreen(filePaths: filePaths);
        },
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
}
