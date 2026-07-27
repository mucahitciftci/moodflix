import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Raw Hive read/write for everything stored on-device: the movie discovery
/// cache (source+page → TMDB JSON, for stale-while-revalidate — a "source"
/// is either a mood or a genre, see `DiscoverySource`) and the user's two
/// local movie lists — "İzleyeceklerim" (watchlist) and "Favorilerim"
/// (favorites) — which are local-first and never touch the network.
class LocalCacheService {
  static const String moviePagesBoxName = 'movie_pages_cache';
  static const String watchlistBoxName = 'watchlist_movies';
  static const String favoritesBoxName = 'favorite_movies';

  /// Must be awaited once, before `runApp`, so every box is open by the
  /// time any repository reads from it.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(moviePagesBoxName);
    await Hive.openBox<dynamic>(watchlistBoxName);
    await Hive.openBox<dynamic>(favoritesBoxName);
  }

  Box<dynamic> get _moviePagesBox => Hive.box<dynamic>(moviePagesBoxName);
  Box<dynamic> get _watchlistBox => Hive.box<dynamic>(watchlistBoxName);
  Box<dynamic> get _favoritesBox => Hive.box<dynamic>(favoritesBoxName);

  String _pageKey(String sourceKey, int page) => '${sourceKey}_page_$page';

  List<Map<String, dynamic>>? getCachedMoviePage(String sourceKey, int page) {
    final raw = _moviePagesBox.get(_pageKey(sourceKey, page));
    if (raw is! Map) return null;

    final results = raw['results'];
    if (results is! List) return null;

    return results.map((e) => _asStringKeyedMap(e)).toList();
  }

  Future<void> cacheMoviePage({
    required String sourceKey,
    required int page,
    required List<Map<String, dynamic>> results,
  }) {
    return _moviePagesBox.put(_pageKey(sourceKey, page), {'results': results});
  }

  // --- Watchlist ("İzleyeceklerim") ---

  List<Map<String, dynamic>> getWatchlistMovies() => _allMovies(_watchlistBox);

  Future<void> addToWatchlist(Map<String, dynamic> movieJson) =>
      _putMovie(_watchlistBox, movieJson);

  Future<void> removeFromWatchlist(int movieId) =>
      _watchlistBox.delete('$movieId');

  bool isInWatchlist(int movieId) => _watchlistBox.containsKey('$movieId');

  // --- Favorites ("Favorilerim") ---

  List<Map<String, dynamic>> getFavoriteMovies() => _allMovies(_favoritesBox);

  Future<void> addToFavorites(Map<String, dynamic> movieJson) =>
      _putMovie(_favoritesBox, movieJson);

  Future<void> removeFromFavorites(int movieId) =>
      _favoritesBox.delete('$movieId');

  bool isFavorite(int movieId) => _favoritesBox.containsKey('$movieId');

  List<Map<String, dynamic>> _allMovies(Box<dynamic> box) =>
      box.values.map(_asStringKeyedMap).toList();

  Future<void> _putMovie(Box<dynamic> box, Map<String, dynamic> movieJson) {
    return box.put('${movieJson['id']}', movieJson);
  }

  /// Hive returns nested maps as `Map<dynamic, dynamic>`; this recursively
  /// normalizes a cached entry back into the `Map<String, dynamic>` shape
  /// `MovieModel.fromJson` expects.
  Map<String, dynamic> _asStringKeyedMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map((key, v) => MapEntry(key.toString(), _asDartValue(v)));
  }

  dynamic _asDartValue(dynamic value) {
    if (value is Map) return _asStringKeyedMap(value);
    if (value is List) return value.map(_asDartValue).toList();
    return value;
  }
}

final localCacheServiceProvider = Provider<LocalCacheService>((ref) {
  return LocalCacheService();
});
