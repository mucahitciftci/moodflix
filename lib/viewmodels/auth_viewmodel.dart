import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

/// Who's currently signed in, reactive to Firebase Auth's own session
/// persistence — null means signed out. Watch this anywhere the UI needs
/// to gate on login state (e.g. "write a review").
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
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
    state = await AsyncValue.guard(
      () => _service.signUp(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _service.signIn(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_service.signOut);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.sendPasswordResetEmail(email));
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(
  AuthViewModel.new,
);
