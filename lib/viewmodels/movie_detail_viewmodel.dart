import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

/// Fetches the full detail payload (notably the trailer's YouTube key,
/// which list/discover responses never include) for one movie. Keyed by
/// movie id so each detail screen gets its own request. Always live —
/// trailer playback requires connectivity regardless, so there's no point
/// caching this the way discovery pages are cached.
class MovieDetailViewModel extends FamilyAsyncNotifier<MovieModel, int> {
  @override
  Future<MovieModel> build(int movieId) {
    return ref.read(movieRepositoryProvider).fetchMovieDetails(movieId);
  }
}

final movieDetailViewModelProvider =
    AsyncNotifierProvider.family<MovieDetailViewModel, MovieModel, int>(
  MovieDetailViewModel.new,
);
