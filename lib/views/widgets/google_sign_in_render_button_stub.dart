import 'package:flutter/material.dart';

/// Stub for the web-only `renderButton` — `google_sign_in_web` has to sit
/// behind a conditional import since it isn't available on other platforms.
Widget renderGoogleSignInButton() {
  throw StateError('renderGoogleSignInButton is only available on web.');
}
