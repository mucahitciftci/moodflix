import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/auth_viewmodel.dart';
import 'browse_mode_screen.dart';
import 'login_screen.dart';

/// The app's actual initial route ("/"): shows `LoginScreen` first if no
/// one is signed in (with a "continue as guest" option, since browsing and
/// the watchlist never required an account — only reviews do), or
/// `BrowseModeScreen` directly if a session is already active. This is
/// conditional rendering at a fixed route, not a redirect/navigation, so
/// there's no extra route on the stack once the user is past it.
class AuthGateScreen extends ConsumerWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isGuest = ref.watch(guestModeProvider);

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authState.valueOrNull != null || isGuest) {
      return const BrowseModeScreen();
    }

    return const LoginScreen();
  }
}
