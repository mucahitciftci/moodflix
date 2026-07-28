import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../services/shared_list_service.dart';

/// Thin pass-through to [SharedListService], kept for the same
/// architectural consistency reason as [ReviewRepository].
class SharedListRepository {
  SharedListRepository({required SharedListService sharedListService})
      : _service = sharedListService;

  final SharedListService _service;

  Future<void> setWatchlistItem(String uid, MovieModel movie) =>
      _service.setWatchlistItem(uid, movie);

  Future<void> removeWatchlistItem(String uid, int movieId) =>
      _service.removeWatchlistItem(uid, movieId);

  Future<void> setFavoriteItem(String uid, MovieModel movie) =>
      _service.setFavoriteItem(uid, movie);

  Future<void> removeFavoriteItem(String uid, int movieId) =>
      _service.removeFavoriteItem(uid, movieId);

  Stream<List<MovieModel>> watchSharedWatchlist(String uid) =>
      _service.watchSharedWatchlist(uid);

  Stream<List<MovieModel>> watchSharedFavorites(String uid) =>
      _service.watchSharedFavorites(uid);

  Future<void> syncAll({
    required String uid,
    required List<MovieModel> watchlist,
    required List<MovieModel> favorites,
  }) =>
      _service.syncAll(uid: uid, watchlist: watchlist, favorites: favorites);

  Future<void> clearAll(String uid) => _service.clearAll(uid);
}

final sharedListRepositoryProvider = Provider<SharedListRepository>((ref) {
  return SharedListRepository(sharedListService: ref.watch(sharedListServiceProvider));
});
