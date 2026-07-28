import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../repositories/social_repository.dart';
import 'auth_viewmodel.dart';

/// Who the current user follows / who follows a given user — live
/// Firestore listeners, so a follow/unfollow action updates these
/// immediately anywhere they're shown.
final followingProvider =
    StreamProvider.family<List<AppUser>, String>((ref, uid) {
  return ref.watch(socialRepositoryProvider).watchFollowing(uid);
});

final followersProvider =
    StreamProvider.family<List<AppUser>, String>((ref, uid) {
  return ref.watch(socialRepositoryProvider).watchFollowers(uid);
});

/// Whether the signed-in user follows [targetUid]. False (not a stream of
/// false) when signed out — there's nothing to follow with.
final isFollowingProvider = StreamProvider.family<bool, String>((ref, targetUid) {
  final me = ref.watch(authStateProvider).valueOrNull;
  if (me == null) return Stream.value(false);
  return ref.watch(socialRepositoryProvider).watchIsFollowing(me.uid, targetUid);
});

/// Debounced user search, backing `SocialScreen` — same pattern as
/// `MovieSearchViewModel`.
class UserSearchViewModel extends AsyncNotifier<List<AppUser>> {
  Timer? _debounce;

  @override
  Future<List<AppUser>> build() async {
    ref.onDispose(() => _debounce?.cancel());
    return const [];
  }

  void search(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      state = const AsyncLoading();
      try {
        final results = await ref.read(socialRepositoryProvider).searchUsers(query);
        state = AsyncData(results);
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      }
    });
  }
}

final userSearchViewModelProvider =
    AsyncNotifierProvider<UserSearchViewModel, List<AppUser>>(
  UserSearchViewModel.new,
);

/// Follow / unfollow actions, always as the signed-in user.
class FollowViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> follow(String targetUid) async {
    final me = ref.read(authStateProvider).valueOrNull;
    if (me == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(socialRepositoryProvider).follow(me.uid, targetUid),
    );
  }

  Future<void> unfollow(String targetUid) async {
    final me = ref.read(authStateProvider).valueOrNull;
    if (me == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(socialRepositoryProvider).unfollow(me.uid, targetUid),
    );
  }
}

final followViewModelProvider = AsyncNotifierProvider<FollowViewModel, void>(
  FollowViewModel.new,
);
