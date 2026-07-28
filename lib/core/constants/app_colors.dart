import 'package:flutter/material.dart';

/// Centralized color palette. No widget should ever construct a raw
/// `Color(0x...)` — every color used in the UI must come from here.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFE50914);
  static const Color primaryDark = Color(0xFFB20710);
  static const Color secondary = Color(0xFF0F1B2B);

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF5F6FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF0B0D12);
  static const Color darkSurface = Color(0xFF161A22);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFA0A4AC);

  // Feedback
  static const Color error = Color(0xFFCF3D3D);
  static const Color success = Color(0xFF2E9E5B);

  // Swipe stack gestures
  static const Color swipeLike = Color(0xFF2E9E5B);
  static const Color swipeNope = Color(0xFFCF3D3D);

  // Mood accent colors, referenced by MoodConfig
  static const Color moodMindBender = Color(0xFF6C4FD1);
  static const Color moodNostalgia = Color(0xFFD1934F);
  static const Color moodThriller = Color(0xFF8A1A1A);
  static const Color moodNetflix = Color(0xFFE50914);

  // Foreground on saturated mood accent / brand-colored backgrounds
  static const Color onColorSurface = Color(0xFFFFFFFF);

  // Preset avatar palette — background color behind a PresetAvatarIcon
  // silhouette, picked by the user in the avatar builder.
  static const Color avatarPaletteRed = Color(0xFFE53935);
  static const Color avatarPaletteOrange = Color(0xFFFB8C00);
  static const Color avatarPaletteAmber = Color(0xFFD1934F);
  static const Color avatarPaletteGreen = Color(0xFF43A047);
  static const Color avatarPaletteTeal = Color(0xFF00897B);
  static const Color avatarPaletteBlue = Color(0xFF1E88E5);
  static const Color avatarPalettePurple = Color(0xFF6C4FD1);
  static const Color avatarPalettePink = Color(0xFFD81B60);

  static const List<Color> avatarPalette = [
    avatarPaletteRed,
    avatarPaletteOrange,
    avatarPaletteAmber,
    avatarPaletteGreen,
    avatarPaletteTeal,
    avatarPaletteBlue,
    avatarPalettePurple,
    avatarPalettePink,
  ];

  // Explicit "no color" — the canonical source for gradients that fade to
  // nothing, so widgets never reach for `Colors.transparent` directly.
  static const Color transparent = Color(0x00000000);
}
