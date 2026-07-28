import 'package:flutter/foundation.dart';

/// Who can see a user's shared watchlist/favorites, chosen per-user in
/// Settings' "Gizlilik" section — not a single fixed app-wide policy.
enum ListSharingVisibility {
  off,
  public,
  followers;

  String get firestoreValue => switch (this) {
        ListSharingVisibility.off => 'off',
        ListSharingVisibility.public => 'public',
        ListSharingVisibility.followers => 'followers',
      };

  static ListSharingVisibility fromFirestoreValue(String? value) => switch (value) {
        'public' => ListSharingVisibility.public,
        'followers' => ListSharingVisibility.followers,
        _ => ListSharingVisibility.off,
      };
}

/// A public user profile, stored in Firestore's `users` collection —
/// separate from Firebase Auth's own `User` object, which isn't queryable
/// (you can't search/list Firebase Auth accounts from the client). Created
/// or refreshed on sign up, sign in, and display name changes (see
/// `AuthViewModel`), so search/follow always have a name to show.
@immutable
class AppUser {
  final String uid;
  final String displayName;
  final ListSharingVisibility listSharing;

  const AppUser({
    required this.uid,
    required this.displayName,
    this.listSharing = ListSharingVisibility.off,
  });

  factory AppUser.fromFirestore(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      displayName: data['displayName'] as String? ?? '',
      listSharing: ListSharingVisibility.fromFirestoreValue(
        data['listSharing'] as String?,
      ),
    );
  }

  /// Deliberately does NOT include `listSharing` — this is written by
  /// `AuthViewModel` on every sign-in via `SetOptions(merge: true))`, and if
  /// it included the in-memory default (`off`), every login would silently
  /// reset the user's sharing preference back to off. Changing `listSharing`
  /// goes through `UserService.updateListSharing` instead, as its own
  /// targeted write.
  ///
  /// No `createdAt`/timestamp here deliberately either — this doc is
  /// upserted on every sign-in, and including a server timestamp would keep
  /// resetting it. `displayNameLower` exists purely so
  /// `UserService.searchUsers` can do a case-insensitive prefix query
  /// (Firestore has no text search).
  Map<String, dynamic> toFirestore() => {
        'displayName': displayName,
        'displayNameLower': displayName.toLowerCase(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AppUser && other.uid == uid);

  @override
  int get hashCode => uid.hashCode;
}
