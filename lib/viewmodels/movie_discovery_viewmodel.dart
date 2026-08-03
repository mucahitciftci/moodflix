import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/discovery_source.dart';
import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

/// Discovery state for the currently browsed [DiscoverySource] (a mood or a
/// genre): the accumulated movie list (across pages), pagination position,
/// and loading/error flags. Kept as a single object so the view can render
/// cache-then-network without a blank screen in between.
@immutable
class MovieDiscoveryState {
  final DiscoverySource? source;
  final List<MovieModel> movies;
  final int page;
  final bool hasMore;
  final bool isLoadingNextPage;
  final String? errorMessage;

  const MovieDiscoveryState({
    this.source,
    this.movies = const [],
    this.page = 0,
    this.hasMore = true,
    this.isLoadingNextPage = false,
    this.errorMessage,
  });

  MovieDiscoveryState copyWith({
    DiscoverySource? source,
    List<MovieModel>? movies,
    int? page,
    bool? hasMore,
    bool? isLoadingNextPage,
    String? errorMessage,
  }) {
    return MovieDiscoveryState(
      source: source ?? this.source,
      movies: movies ?? this.movies,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      errorMessage: errorMessage,
    );
  }
}

/// Drives the discovery/swipe screen for one [DiscoverySource] at a time —
/// a mood or a genre, both handled identically since [DiscoverySource]
/// already resolves to a cache key + TMDB query params. [load] paints the
/// first page instantly from cache (if any), then refreshes it from the
/// network; [loadNextPage] appends subsequent pages as the stack runs low.
class MovieDiscoveryViewModel extends AsyncNotifier<MovieDiscoveryState> {
  @override
  Future<MovieDiscoveryState> build() async => const MovieDiscoveryState();

  MovieRepository get _repository => ref.read(movieRepositoryProvider);

  /// Movies already on the watchlist or favorites don't need to be swiped
  /// on again. `hasMore`/pagination still tracks the *raw* fetched page
  /// size (see call sites) so a page that happens to be entirely
  /// already-saved movies doesn't look like "no more results" and stop
  /// pagination early.
  List<MovieModel> _excludeAlreadySaved(List<MovieModel> movies) {
    return movies
        .where((movie) =>
            !_repository.isInWatchlist(movie.id) && !_repository.isFavorite(movie.id))
        .toList();
  }

  /// `TrendingSource` has no mood/genre filter to send through
  /// `/discover/movie` — it hits TMDB's own trending ranking instead, via a
  /// dedicated repository method. Every other source goes through the
  /// generic `fetchPage`.
  Future<List<MovieModel>> _fetchPage(DiscoverySource source, int page) {
    if (source is TrendingSource) return _repository.fetchTrendingPage(page);
    return _repository.fetchPage(
      sourceKey: source.cacheKey,
      queryParams: source.queryParams,
      page: page,
    );
  }

  /// Switches the screen to [source]: shows the cached first page instantly
  /// (if present), then fetches a fresh first page from the network.
  Future<void> load(DiscoverySource source) async {
    final cached = _excludeAlreadySaved(_repository.cachedPage(source.cacheKey, 1));
    state = AsyncData(
      MovieDiscoveryState(source: source, movies: cached, page: 1),
    );

    try {
      final fresh = await _fetchPage(source, 1);
      state = AsyncData(
        MovieDiscoveryState(
          source: source,
          movies: _excludeAlreadySaved(fresh),
          page: 1,
          hasMore: fresh.isNotEmpty,
        ),
      );
    } catch (e) {
      final current =
          state.value ?? MovieDiscoveryState(source: source, movies: cached, page: 1);
      state = AsyncData(current.copyWith(errorMessage: e.toString()));
    }
  }

  /// Fetches and appends the next page for the currently loaded source.
  /// No-ops if nothing is loaded, a fetch is already in flight, or the
  /// previous page came back empty (no more results).
  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || current.source == null) return;
    if (current.isLoadingNextPage || !current.hasMore) return;

    state = AsyncData(
      current.copyWith(isLoadingNextPage: true, errorMessage: null),
    );

    final source = current.source!;
    final nextPage = current.page + 1;

    try {
      final fetched = await _fetchPage(source, nextPage);
      final updated = state.value ?? current;
      state = AsyncData(
        updated.copyWith(
          movies: [...updated.movies, ..._excludeAlreadySaved(fetched)],
          page: nextPage,
          hasMore: fetched.isNotEmpty,
          isLoadingNextPage: false,
        ),
      );
    } catch (e) {
      final updated = state.value ?? current;
      state = AsyncData(
        updated.copyWith(isLoadingNextPage: false, errorMessage: e.toString()),
      );
    }
  }
}

final movieDiscoveryViewModelProvider =
    AsyncNotifierProvider<MovieDiscoveryViewModel, MovieDiscoveryState>(
  MovieDiscoveryViewModel.new,
);
