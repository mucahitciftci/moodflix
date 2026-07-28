import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';
import '../repositories/shared_list_repository.dart';
import '../repositories/social_repository.dart';
import 'auth_viewmodel.dart';

/// Live profile for any uid — used by `UserProfileScreen` to always show
/// that user's *current* `listSharing` choice (not whatever it was when
/// search/follow results were fetched).
final userProfileProvider = StreamProvider.family<AppUser?, String>((ref, uid) {
  return ref.watch(socialRepositoryProvider).watchUser(uid);
});

/// The signed-in user's own live profile — null when signed out.
final currentUserProfileProvider = StreamProvider<AppUser?>((ref) {
  final me = ref.watch(authStateProvider).valueOrNull;
  if (me == null) return Stream.value(null);
  return ref.watch(socialRepositoryProvider).watchUser(me.uid);
});

final sharedWatchlistProvider =
    StreamProvider.family<List<MovieModel>, String>((ref, uid) {
  return ref.watch(sharedListRepositoryProvider).watchSharedWatchlist(uid);
});

final sharedFavoritesProvider =
    StreamProvider.family<List<MovieModel>, String>((ref, uid) {
  return ref.watch(sharedListRepositoryProvider).watchSharedFavorites(uid);
});

/// Changes the signed-in user's list-sharing visibility. Turning sharing ON
/// bulk-pushes everything currently in the local Hive watchlist/favorites
/// to Firestore (so it's visible immediately, not just future changes);
/// turning it OFF wipes the Firestore mirror. Individual add/remove
/// mirroring while sharing stays on happens in `WatchlistViewModel`/
/// `FavoritesViewModel`, not here.
class ListSharingViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> setVisibility(ListSharingVisibility visibility) async {
    final me = ref.read(authStateProvider).valueOrNull;
    if (me == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(socialRepositoryProvider).updateListSharing(me.uid, visibility);

      final sharedRepo = ref.read(sharedListRepositoryProvider);
      if (visibility == ListSharingVisibility.off) {
        await sharedRepo.clearAll(me.uid);
      } else {
        final movieRepo = ref.read(movieRepositoryProvider);
        await sharedRepo.syncAll(
          uid: me.uid,
          watchlist: movieRepo.getWatchlist(),
          favorites: movieRepo.getFavorites(),
        );
      }
    });
  }
}

final listSharingViewModelProvider =
    AsyncNotifierProvider<ListSharingViewModel, void>(ListSharingViewModel.new);
