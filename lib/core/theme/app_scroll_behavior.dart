import 'package:flutter/material.dart';

/// Disables Android's "stretch" overscroll effect app-wide — it visibly
/// scaled/stretched cards near the top/bottom of scrollable lists (movie
/// detail, Menü), which read as a bug rather than a deliberate effect.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
