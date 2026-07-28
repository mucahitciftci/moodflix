import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';
import '../repositories/shared_list_repository.dart';
import 'auth_viewmodel.dart';
import 'list_sharing_viewmodel.dart';

/// The user's "İzleyeceklerim" list — movies swiped right on the discovery
/// screen. Backed entirely by Hive via [MovieRepository], so it's available
/// fully offline and survives app restarts, regardless of sign-in state.
/// If the signed-in user has list sharing on, adds/removes are also
/// mirrored to Firestore (`SharedListRepository`) so followers/the public
/// can see it, per `ListSharingViewModel`.
class WatchlistViewModel extends Notifier<List<MovieModel>> {
  @override
  List<MovieModel> build() => _repository.getWatchlist();

  MovieRepository get _repository => ref.read(movieRepositoryProvider);

  bool contains(int movieId) => _repository.isInWatchlist(movieId);

  Future<void> add(MovieModel movie) async {
    if (contains(movie.id)) return;
    await _repository.addToWatchlist(movie);
    state = _repository.getWatchlist();
    await _mirrorAdd(movie);
  }

  Future<void> remove(int movieId) async {
    await _repository.removeFromWatchlist(movieId);
    state = _repository.getWatchlist();
    await _mirrorRemove(movieId);
  }

  Future<void> _mirrorAdd(MovieModel movie) async {
    final me = ref.read(authStateProvider).valueOrNull;
    final profile = ref.read(currentUserProfileProvider).valueOrNull;
    if (me == null || profile == null) return;
    if (profile.listSharing == ListSharingVisibility.off) return;
    await ref.read(sharedListRepositoryProvider).setWatchlistItem(me.uid, movie);
  }

  Future<void> _mirrorRemove(int movieId) async {
    final me = ref.read(authStateProvider).valueOrNull;
    final profile = ref.read(currentUserProfileProvider).valueOrNull;
    if (me == null || profile == null) return;
    if (profile.listSharing == ListSharingVisibility.off) return;
    await ref.read(sharedListRepositoryProvider).removeWatchlistItem(me.uid, movieId);
  }
}

final watchlistViewModelProvider =
    NotifierProvider<WatchlistViewModel, List<MovieModel>>(
  WatchlistViewModel.new,
);
