import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

/// The user's "İzleyeceklerim" list — movies swiped right on the discovery
/// screen. Backed entirely by Hive via [MovieRepository], so it's available
/// fully offline and survives app restarts.
class WatchlistViewModel extends Notifier<List<MovieModel>> {
  @override
  List<MovieModel> build() => _repository.getWatchlist();

  MovieRepository get _repository => ref.read(movieRepositoryProvider);

  bool contains(int movieId) => _repository.isInWatchlist(movieId);

  Future<void> add(MovieModel movie) async {
    if (contains(movie.id)) return;
    await _repository.addToWatchlist(movie);
    state = _repository.getWatchlist();
  }

  Future<void> remove(int movieId) async {
    await _repository.removeFromWatchlist(movieId);
    state = _repository.getWatchlist();
  }
}

final watchlistViewModelProvider =
    NotifierProvider<WatchlistViewModel, List<MovieModel>>(
  WatchlistViewModel.new,
);
