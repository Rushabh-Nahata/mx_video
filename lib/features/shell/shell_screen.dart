import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart'; // needed for indicatorColor

/// Persistent scaffold with bottom navigation bar.
/// [child] is the active tab's screen, injected by GoRouter's ShellRoute.
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    RouteNames.library,
    RouteNames.browser,
    RouteNames.transfer,
    RouteNames.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _tabIndexFor(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        indicatorColor: AppColors.primary.withAlpha(40),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _tabIndexFor(String location) {
    if (location.startsWith(RouteNames.browser)) return 1;
    if (location.startsWith(RouteNames.transfer)) return 2;
    if (location.startsWith(RouteNames.settings)) return 3;
    return 0; // library is default
  }
}
