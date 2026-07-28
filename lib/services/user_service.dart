import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/preset_avatar_config.dart';
import '../models/app_user.dart';

/// Raw Firestore read/write for the `users` collection — public profile
/// data (currently just a display name), used for search and follow.
class UserService {
  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> upsertUser(AppUser user) {
    return _users.doc(user.uid).set(user.toFirestore(), SetOptions(merge: true));
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    final data = doc.data();
    if (data == null) return null;
    return AppUser.fromFirestore(doc.id, data);
  }

  /// Live version of [getUser] — used wherever a change to `listSharing`
  /// (or a display name update) needs to be reflected immediately, e.g.
  /// the Settings privacy picker and `UserProfileScreen`.
  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return AppUser.fromFirestore(doc.id, data);
    });
  }

  /// Targeted write of just `listSharing` — see `AppUser.toFirestore`'s doc
  /// comment for why this can't go through the general `upsertUser` path.
  Future<void> updateListSharing(String uid, ListSharingVisibility visibility) {
    return _users.doc(uid).set(
      {'listSharing': visibility.firestoreValue},
      SetOptions(merge: true),
    );
  }

  /// Targeted write of just `photoBase64` — same reasoning as
  /// [updateListSharing]. Pass `null` to clear the photo.
  Future<void> updatePhoto(String uid, String? base64) {
    return _users.doc(uid).set(
      {'photoBase64': base64},
      SetOptions(merge: true),
    );
  }

  /// Targeted write of a preset (animal + color) avatar — also clears
  /// `photoBase64` in the same write, so the preset becomes the visibly
  /// active avatar immediately (`UserAvatar` prioritizes a real photo over
  /// a preset when both happen to be set).
  Future<void> updatePresetAvatar(String uid, PresetAnimal animal, int colorValue) {
    return _users.doc(uid).set(
      {
        'presetAvatarAnimal': animal.name,
        'presetAvatarColorValue': colorValue,
        'photoBase64': null,
      },
      SetOptions(merge: true),
    );
  }

  /// Case-insensitive prefix search on `displayNameLower` — Firestore has
  /// no full-text search, so this only matches names starting with [query].
  /// A one-shot fetch (not a live stream) — matches `MovieRepository.searchMovies`'s
  /// pattern, since search results don't need to be reactive.
  Future<List<AppUser>> searchUsers(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return const [];

    final snapshot = await _users
        .where('displayNameLower', isGreaterThanOrEqualTo: normalized)
        .where('displayNameLower', isLessThan: '$normalized')
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => AppUser.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}

final userServiceProvider = Provider<UserService>((ref) => UserService());
