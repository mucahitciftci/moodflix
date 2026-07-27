import 'package:flutter/material.dart';

import '../../models/discovery_source.dart';
import '../../models/movie_model.dart';
import '../../views/screens/browse_mode_screen.dart';
import '../../views/screens/category_selection_screen.dart';
import '../../views/screens/discovery_screen.dart';
import '../../views/screens/mood_selection_screen.dart';
import '../../views/screens/movie_detail_screen.dart';
import '../../views/screens/search_screen.dart';
import '../../views/screens/settings_screen.dart';
import '../../views/screens/watchlist_screen.dart';

/// Named route identifiers. No `Navigator.push`/`pushNamed` call anywhere in
/// the app should ever use a raw route string — it must reference one of
/// these constants.
abstract final class AppRoutes {
  static const String browseMode = '/';
  static const String moodSelection = '/mood-selection';
  static const String categorySelection = '/category-selection';
  static const String discovery = '/discovery';
  static const String watchlist = '/watchlist';
  static const String movieDetail = '/movie-detail';
  static const String search = '/search';
  static const String settings = '/settings';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.moodSelection:
        return MaterialPageRoute(
          builder: (_) => const MoodSelectionScreen(),
          settings: settings,
        );
      case AppRoutes.categorySelection:
        return MaterialPageRoute(
          builder: (_) => const CategorySelectionScreen(),
          settings: settings,
        );
      case AppRoutes.discovery:
        final source = settings.arguments as DiscoverySource;
        return MaterialPageRoute(
          builder: (_) => DiscoveryScreen(source: source),
          settings: settings,
        );
      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      case AppRoutes.watchlist:
        return MaterialPageRoute(
          builder: (_) => const WatchlistScreen(),
          settings: settings,
        );
      case AppRoutes.movieDetail:
        final movie = settings.arguments as MovieModel;
        return MaterialPageRoute(
          builder: (_) => MovieDetailScreen(movie: movie),
          settings: settings,
        );
      case AppRoutes.browseMode:
      default:
        return MaterialPageRoute(
          builder: (_) => const BrowseModeScreen(),
          settings: settings,
        );
    }
  }
}
