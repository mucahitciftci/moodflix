import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../services/follow_service.dart';
import '../services/user_service.dart';

/// Bridges [UserService] (profiles) and [FollowService] (follow
/// relationships) into [AppUser] data view models consume. Follow lists
/// resolve `follows` docs (which only store IDs) into full [AppUser]
/// profiles here, so callers never deal with raw uid lists.
class SocialRepository {
  SocialRepository({
    required UserService userService,
    required FollowService followService,
  })  : _userService = userService,
        _followService = followService;

  final UserService _userService;
  final FollowService _followService;

  Future<void> upsertUser(AppUser user) => _userService.upsertUser(user);

  Stream<AppUser?> watchUser(String uid) => _userService.watchUser(uid);

  Future<void> updateListSharing(String uid, ListSharingVisibility visibility) =>
      _userService.updateListSharing(uid, visibility);

  Future<List<AppUser>> searchUsers(String query) =>
      _userService.searchUsers(query);

  Future<void> follow(String followerId, String followingId) =>
      _followService.follow(followerId, followingId);

  Future<void> unfollow(String followerId, String followingId) =>
      _followService.unfollow(followerId, followingId);

  Stream<bool> watchIsFollowing(String followerId, String followingId) =>
      _followService.watchIsFollowing(followerId, followingId);

  Stream<List<AppUser>> watchFollowing(String uid) {
    return _followService.watchFollowingIds(uid).asyncMap(_resolveUsers);
  }

  Stream<List<AppUser>> watchFollowers(String uid) {
    return _followService.watchFollowerIds(uid).asyncMap(_resolveUsers);
  }

  Future<List<AppUser>> _resolveUsers(List<String> uids) async {
    final users = await Future.wait(uids.map(_userService.getUser));
    return users.whereType<AppUser>().toList();
  }
}

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(
    userService: ref.watch(userServiceProvider),
    followService: ref.watch(followServiceProvider),
  );
});
