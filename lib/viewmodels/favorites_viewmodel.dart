import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

/// The user's "Favorilerim" list, set from the movie detail screen. Backed
/// entirely by Hive via [MovieRepository], so it's available fully offline
/// and survives app restarts.
class FavoritesViewModel extends Notifier<List<MovieModel>> {
  @override
  List<MovieModel> build() => _repository.getFavorites();

  MovieRepository get _repository => ref.read(movieRepositoryProvider);

  bool contains(int movieId) => _repository.isFavorite(movieId);

  Future<void> add(MovieModel movie) async {
    if (contains(movie.id)) return;
    await _repository.addToFavorites(movie);
    state = _repository.getFavorites();
  }

  Future<void> remove(int movieId) async {
    await _repository.removeFromFavorites(movieId);
    state = _repository.getFavorites();
  }
}

final favoritesViewModelProvider =
    NotifierProvider<FavoritesViewModel, List<MovieModel>>(
  FavoritesViewModel.new,
);
