import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> signOut() => _auth.signOut();

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
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
