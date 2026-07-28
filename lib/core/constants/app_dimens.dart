/// Centralized spacing, radius and sizing scale. No widget should ever use
/// a raw padding/margin/size number — every dimension must come from here.
abstract final class AppDimens {
  // Spacing scale
  static const double spaceXs = 4;
  static const double spaceS = 8;
  static const double spaceM = 16;
  static const double spaceL = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;

  // Border radius
  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusL = 24;
  static const double radiusPill = 999;

  // Mood selection grid
  static const double moodChipHeight = 56;
  static const double moodIconSize = 28;
  static const int moodGridCrossAxisCount = 2;
  static const double moodGridAspectRatio = 1.1;

  // Movie card / swipe stack
  static const double cardWidthFraction = 0.86;
  static const double cardHeightFraction = 0.68;
  static const double cardBorderWidth = 1.5;
  static const double posterAspectRatio = 2 / 3;
  static const double swipeThreshold = 120;
  static const double swipeRotationFactor = 0.0008;
  static const int swipeAnimationDurationMs = 220;
  static const int stackVisibleCardCount = 3;
  static const double stackCardScaleStep = 0.05;
  static const double stackCardOffsetStep = 8;

  // Discovery list (pre-swipe-stack) poster thumbnail
  static const double listPosterWidth = 48;

  // Movie detail screen
  static const double backdropAspectRatio = 16 / 9;

  // Scroll pagination threshold (distance from bottom, in px)
  static const double paginationThreshold = 300;

  // Icon sizes
  static const double iconS = 16;
  static const double iconM = 24;
  static const double iconL = 32;
  static const double iconXl = 40;

  // App bar
  static const double appBarHeightLarge = 72;
  static const double appBarLeadingWidthWide = 96;

  // Browse-mode selection screen (mood vs. category)
  static const double browseModeCardHeight = 120;

  // User reviews
  static const int reviewMaxRating = 5;
  static const int reviewTextMaxLength = 2000;

  // Auth forms (login/sign up) — centered, capped width on wide screens
  static const double authFormMaxWidth = 400;

  // User avatars (profile photo, or a fallback person icon)
  static const double avatarRadiusS = 14;
  static const double avatarRadiusM = 20;
  static const double avatarRadiusL = 40;

  // Profile photo: resized client-side before being stored as base64 in
  // the user's Firestore doc (no Firebase Storage — see AppUser doc
  // comment), so it stays small enough to comfortably fit Firestore's
  // 1 MiB per-document limit alongside the doc's other fields.
  static const double profilePhotoMaxDimension = 256;
  static const int profilePhotoQuality = 70;
  static const int profilePhotoMaxBase64Length = 700000;

  // Elevation
  static const double elevationS = 2;
  static const double elevationM = 6;
}
