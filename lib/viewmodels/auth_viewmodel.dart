import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../core/constants/app_dimens.dart';
import '../core/constants/preset_avatar_config.dart';
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
  Future<void> build() async {
    // On web, Google sign-in completes via the SDK's own rendered button
    // (see `LoginScreen`) rather than an imperative call — this is what
    // picks up that result and finishes the Firebase + profile-sync side.
    // `ensureGoogleSignInReady` never throws (see `AuthService`), so a
    // missing/rejected client ID just leaves Google sign-in unavailable
    // instead of breaking the rest of this notifier's `build()`.
    if (kIsWeb) {
      await _service.ensureGoogleSignInReady();
      if (_service.googleSignInAvailable) {
        _service.googleSignInEventsForWeb.listen((_) async {
          final name = _service.currentUser?.displayName;
          if (name != null && name.isNotEmpty) await _upsertProfile(name);
        });
      }
    }
  }

  AuthService get _service => ref.read(authServiceProvider);

  Future<void> ensureGoogleSignInReady() => _service.ensureGoogleSignInReady();

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

  /// Native/imperative Google sign-in for Android/iOS/desktop — **not
  /// called on web**, where the SDK's own rendered button drives sign-in
  /// instead (see `build`'s `googleSignInEventsForWeb` subscription).
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _service.signInWithGoogle();
      final name = _service.currentUser?.displayName;
      if (name != null && name.isNotEmpty) await _upsertProfile(name);
    });
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _service.signInWithApple();
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

  /// Opens the system photo picker, resizes/compresses client-side (via
  /// `ImagePicker`'s own `maxWidth`/`maxHeight`/`imageQuality`, no separate
  /// image-processing package needed), then stores it as base64 on the
  /// user's Firestore doc. No Firebase Storage involved — see `AppUser`'s
  /// doc comment for why. A no-op if the user cancels the picker.
  Future<void> pickAndUpdatePhoto(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: AppDimens.profilePhotoMaxDimension,
      maxHeight: AppDimens.profilePhotoMaxDimension,
      imageQuality: AppDimens.profilePhotoQuality,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final base64 = base64Encode(bytes);
    if (base64.length > AppDimens.profilePhotoMaxBase64Length) {
      state = AsyncError(
        Exception('Selected photo is too large after compression.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = _service.currentUser?.uid;
      if (uid == null) return;
      await ref.read(socialRepositoryProvider).updatePhoto(uid, base64);
    });
  }

  Future<void> removePhoto() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = _service.currentUser?.uid;
      if (uid == null) return;
      await ref.read(socialRepositoryProvider).updatePhoto(uid, null);
    });
  }

  Future<void> setPresetAvatar(PresetAnimal animal, Color color) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = _service.currentUser?.uid;
      if (uid == null) return;
      await ref
          .read(socialRepositoryProvider)
          .updatePresetAvatar(uid, animal, color.toARGB32());
    });
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
