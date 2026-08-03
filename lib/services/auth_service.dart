import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../core/constants/api_constants.dart';

/// Thin wrapper around Firebase Auth (email/password). There's no
/// `AuthRepository` layer the way movies/reviews have one — Firebase Auth
/// already persists the session itself, so there's no local+remote source
/// to reconcile; [AuthViewModel] talks to this directly.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// `userChanges()` rather than `authStateChanges()` — the latter only
  /// fires on sign-in/sign-out, so a display name update wouldn't be
  /// reflected anywhere the UI reads it (e.g. the personalized greeting on
  /// `BrowseModeScreen`) until the next full sign-in.
  Stream<User?> get userChanges => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
  }

  Future<void> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    if (_googleSignInAvailable) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Best-effort — a Google-side hiccup must never block the actual
        // Firebase sign-out below.
      }
    }
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateDisplayName(String displayName) async {
    await _auth.currentUser?.updateDisplayName(displayName);
  }

  /// Sends a confirmation link to [newEmail] — the address only actually
  /// changes once the user clicks it (`verifyBeforeUpdateEmail`, the
  /// current recommended API; the old `updateEmail` is deprecated and
  /// increasingly rejected by Firebase for security reasons).
  Future<void> updateEmail(String newEmail) async {
    await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
  }

  /// Password changes require a recent sign-in, so this re-authenticates
  /// with [currentPassword] first — without it, `updatePassword` almost
  /// always fails with `requires-recent-login`.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) return;

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  // --- Google Sign-In ---------------------------------------------------

  Future<void>? _googleSignInReady;
  bool _googleSignInAvailable = false;

  /// Whether Google Sign-In actually initialized successfully — false if
  /// `GOOGLE_WEB_CLIENT_ID` isn't configured yet, or the SDK rejected it.
  /// Callers (the login screen) should hide/disable Google sign-in rather
  /// than call [signInWithGoogle] when this is false.
  bool get googleSignInAvailable => _googleSignInAvailable;

  /// `GoogleSignIn.instance.initialize()` must complete exactly once before
  /// any other call on it — this memoizes that single call so it's safe to
  /// invoke from multiple places (e.g. before rendering the web button, and
  /// again before an imperative [signInWithGoogle] call) without triggering
  /// "undefined behavior" from a second `initialize()`. Never throws — an
  /// unset/rejected client ID just leaves [googleSignInAvailable] false
  /// instead of breaking the rest of the auth system (see `AuthViewModel`,
  /// which awaits this during `build()`).
  Future<void> ensureGoogleSignInReady() {
    return _googleSignInReady ??= _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    if (ApiConstants.googleWebClientId.isEmpty) return;
    try {
      // `google_sign_in_web` rejects a non-null serverClientId outright
      // ("serverClientId is not supported on Web") — the two params are
      // mutually exclusive per platform: web only wants clientId, native
      // (Android/iOS) only wants serverClientId (that's what makes them
      // return a Firebase-verifiable ID token).
      await GoogleSignIn.instance.initialize(
        clientId: kIsWeb ? ApiConstants.googleWebClientId : null,
        serverClientId: kIsWeb ? null : ApiConstants.googleWebClientId,
      );
      _googleSignInAvailable = true;
    } catch (_) {
      // Leave unavailable — a misconfigured/rejected client ID shouldn't
      // break email/password auth or anything else.
    }
  }

  Future<UserCredential> _signInToFirebaseWithGoogleAccount(
    GoogleSignInAccount account,
  ) {
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError('Google sign-in did not return an ID token.');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  /// Imperative sign-in flow for Android/iOS/desktop, where the platform
  /// supports triggering the native account picker directly. **Not used on
  /// web** — Google's GIS SDK requires its own rendered button there
  /// instead (see [googleSignInEventsForWeb]).
  Future<UserCredential> signInWithGoogle() async {
    await ensureGoogleSignInReady();
    if (!_googleSignInAvailable) {
      throw StateError(
        'Google sign-in is not configured (missing GOOGLE_WEB_CLIENT_ID).',
      );
    }
    final account = await GoogleSignIn.instance.authenticate();
    return _signInToFirebaseWithGoogleAccount(account);
  }

  /// On web, the GIS SDK's own rendered button (`GoogleSignInButton`)
  /// handles the click and reports success via this event stream, rather
  /// than through an imperative call like [signInWithGoogle].
  Stream<UserCredential> get googleSignInEventsForWeb {
    return GoogleSignIn.instance.authenticationEvents
        .where((event) => event is GoogleSignInAuthenticationEventSignIn)
        .cast<GoogleSignInAuthenticationEventSignIn>()
        .asyncMap((event) => _signInToFirebaseWithGoogleAccount(event.user));
  }

  // --- Apple Sign-In ------------------------------------------------------

  Future<UserCredential> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256Hash(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    final userCredential = await _auth.signInWithCredential(oauthCredential);

    // Apple only ever returns the user's name on the very first
    // authorization (never again on subsequent sign-ins), and Firebase
    // doesn't pick it up automatically — set it ourselves while we have it.
    final user = userCredential.user;
    final fullName = [appleCredential.givenName, appleCredential.familyName]
        .whereType<String>()
        .join(' ')
        .trim();
    if (user != null && fullName.isNotEmpty && (user.displayName?.isEmpty ?? true)) {
      await user.updateDisplayName(fullName);
    }

    return userCredential;
  }

  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String _sha256Hash(String input) =>
      sha256.convert(utf8.encode(input)).toString();
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
