// Route guards are wired into GoRouter via [redirect] callbacks.
// Add guards here as the app grows (e.g., onboarding, permission gate).

import 'package:go_router/go_router.dart';

/// Returns a redirect path if the user should be redirected, or null to allow.
typedef GuardFn = String? Function(GoRouterState state);

/// Chains multiple guards. Returns the first non-null redirect.
String? chainGuards(GoRouterState state, List<GuardFn> guards) {
  for (final guard in guards) {
    final redirect = guard(state);
    if (redirect != null) return redirect;
  }
  return null;
}

// TODO: Add onboarding guard (show permission screen on first launch)
// TODO: Add player guard (redirect if file path is missing)
