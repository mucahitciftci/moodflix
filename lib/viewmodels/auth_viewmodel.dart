import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../repositories/social_repository.dart';
import '../services/auth_service.dart';

/// Who's currently signed in, reactive to Firebase Auth's own session
/// persistence — null means signed out. Watch this anywhere the UI needs
/// to gate on login state (e.g. "write a review").
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).userChanges;
});

/// Sign up / sign in / sign out / password reset actions. Screens watch
/// this for loading/error state while an action is in flight; watch
/// [authStateProvider] separately for "who is logged in right now" — this
/// notifier's own state carries no user data, just the action's progress.
class AuthViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthService get _service => ref.read(authServiceProvider);

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _service.signUp(email: email, password: password, displayName: displayName);
      await _upsertProfile(displayName);
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _service.signIn(email: email, password: password);
      // Self-heals the public `users/{uid}` profile doc for accounts
      // created before this doc existed, and keeps it in sync generally.
      final name = _service.currentUser?.displayName;
      if (name != null && name.isNotEmpty) await _upsertProfile(name);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_service.signOut);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.sendPasswordResetEmail(email));
  }

  Future<void> updateDisplayName(String displayName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _service.updateDisplayName(displayName);
      await _upsertProfile(displayName);
    });
  }

  /// Keeps the public `users/{uid}` profile doc (used for search/follow)
  /// in sync with Firebase Auth's own `displayName`.
  Future<void> _upsertProfile(String displayName) async {
    final uid = _service.currentUser?.uid;
    if (uid == null) return;
    await ref
        .read(socialRepositoryProvider)
        .upsertUser(AppUser(uid: uid, displayName: displayName));
  }

  Future<void> updateEmail(String newEmail) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.updateEmail(newEmail));
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _service.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(
  AuthViewModel.new,
);

/// Whether the user chose "continue as guest" on the startup auth gate
/// (`AuthGateScreen`) instead of signing in. Deliberately in-memory only
/// (resets on relaunch) — each fresh app open re-offers the choice, and a
/// user who signed in stays in via Firebase's own persisted session
/// regardless of this flag.
class GuestModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void continueAsGuest() => state = true;
}

final guestModeProvider = NotifierProvider<GuestModeNotifier, bool>(
  GuestModeNotifier.new,
);
