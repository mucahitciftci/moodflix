import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Renders the GIS SDK's own Google Sign-In button — required on web,
/// where a custom app-styled button can no longer trigger sign-in directly
/// (see `AuthService.googleSignInEventsForWeb`).
Widget renderGoogleSignInButton() {
  return web.renderButton(
    configuration: web.GSIButtonConfiguration(
      theme: web.GSIButtonTheme.filledBlack,
      shape: web.GSIButtonShape.pill,
      size: web.GSIButtonSize.large,
    ),
  );
}
