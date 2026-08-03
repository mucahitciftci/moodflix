import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../services/local_cache_service.dart';
import '../services/tmdb_api_service.dart';

/// Bridges [TmdbApiService] (network) and [LocalCacheService] (Hive) into
/// the processed [MovieModel] data view models consume. Callers get a
/// stale-while-revalidate flow: read [cachedPage] synchronously for an
/// instant first paint, then call [fetchPage] to refresh from the network.
/// Generic over `sourceKey`/`queryParams` rather than mood-specific, so the
/// same discovery pipeline serves both mood-based and genre-based browsing
/// (see `DiscoverySource`) without a second implementation.
class MovieRepository {
  MovieRepository({
    required TmdbApiService apiService,
    required LocalCacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  final TmdbApiService _apiService;
  final LocalCacheService _cacheService;

  /// Synchronous cache read for [sourceKey]'s [page] — used to paint the UI
  /// instantly, before the network call in [fetchPage] resolves. Returns an
  /// empty list on a cache miss (e.g. first launch, or offline).
  List<MovieModel> cachedPage(String sourceKey, int page) {
    final cached = _cacheService.getCachedMoviePage(sourceKey, page);
    if (cached == null) return const [];
    return cached.map(MovieModel.fromJson).toList();
  }

  /// Fetches [page] of TMDB `/discover/movie` results for [queryParams],
  /// writes the raw JSON back to cache under [sourceKey], and returns the
  /// parsed models in random order — TMDB's own sort (rating/popularity) is
  /// deterministic, so results felt repetitive without this.
  Future<List<MovieModel>> fetchPage({
    required String sourceKey,
    required Map<String, String> queryParams,
    required int page,
  }) async {
    final json = await _apiService.discoverMovies(
      queryParams: queryParams,
      page: page,
    );
    final results =
        (json['results'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    await _cacheService.cacheMoviePage(
      sourceKey: sourceKey,
      page: page,
      results: results,
    );

    return results.map(MovieModel.fromJson).toList()..shuffle();
  }

  /// Fetches [page] of TMDB's actual trending ranking (`/trending/movie/week`,
  /// no filters to apply — see `TrendingSource`), cached under the fixed
  /// `sourceKey` `'trending'`. Otherwise mirrors [fetchPage] exactly
  /// (cache write, shuffle for swipe-stack variety).
  Future<List<MovieModel>> fetchTrendingPage(int page) async {
    const sourceKey = 'trending';
    final json = await _apiService.trendingMovies(page: page);
    final results =
        (json['results'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    await _cacheService.cacheMoviePage(
      sourceKey: sourceKey,
      page: page,
      results: results,
    );

    return results.map(MovieModel.fromJson).toList()..shuffle();
  }

  /// Free-text title search via `/search/movie`. Always live — search
  /// results aren't cached, unlike discovery pages.
  Future<List<MovieModel>> searchMovies(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final json = await _apiService.searchMovies(trimmed);
    final results =
        (json['results'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    return results.map(MovieModel.fromJson).toList();
  }

  /// Fetches full details for a single movie, including the trailer's
  /// YouTube key. Always live — the detail screen's trailer playback
  /// requires connectivity regardless, per the offline-first rules.
  Future<MovieModel> fetchMovieDetails(int movieId) async {
    final json = await _apiService.getMovieDetails(movieId);
    return MovieModel.fromJson(json);
  }

  // --- Watchlist ("İzleyeceklerim") — local-only, no network involved. ---

  List<MovieModel> getWatchlist() =>
      _cacheService.getWatchlistMovies().map(MovieModel.fromJson).toList();

  Future<void> addToWatchlist(MovieModel movie) =>
      _cacheService.addToWatchlist(movie.toJson());

  Future<void> removeFromWatchlist(int movieId) =>
      _cacheService.removeFromWatchlist(movieId);

  bool isInWatchlist(int movieId) => _cacheService.isInWatchlist(movieId);

  // --- Favorites ("Favorilerim") — local-only, no network involved. ---

  List<MovieModel> getFavorites() =>
      _cacheService.getFavoriteMovies().map(MovieModel.fromJson).toList();

  Future<void> addToFavorites(MovieModel movie) =>
      _cacheService.addToFavorites(movie.toJson());

  Future<void> removeFromFavorites(int movieId) =>
      _cacheService.removeFromFavorites(movieId);

  bool isFavorite(int movieId) => _cacheService.isFavorite(movieId);
}

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository(
    apiService: ref.watch(tmdbApiServiceProvider),
    cacheService: ref.watch(localCacheServiceProvider),
  );
});
