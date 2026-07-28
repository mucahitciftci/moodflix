import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Raw Firestore read/write for the `follows` collection. Each follow
/// relationship is a single doc, ID'd `{followerId}_{followingId}` so
/// existence checks/creates/deletes are all a single doc reference instead
/// of a query.
class FollowService {
  FollowService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _follows =>
      _firestore.collection('follows');

  String _followDocId(String followerId, String followingId) =>
      '${followerId}_$followingId';

  Future<void> follow(String followerId, String followingId) {
    return _follows.doc(_followDocId(followerId, followingId)).set({
      'followerId': followerId,
      'followingId': followingId,
    });
  }

  Future<void> unfollow(String followerId, String followingId) {
    return _follows.doc(_followDocId(followerId, followingId)).delete();
  }

  Stream<bool> watchIsFollowing(String followerId, String followingId) {
    return _follows
        .doc(_followDocId(followerId, followingId))
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<List<String>> watchFollowingIds(String uid) {
    return _follows.where('followerId', isEqualTo: uid).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data()['followingId'] as String)
              .toList(),
        );
  }

  Stream<List<String>> watchFollowerIds(String uid) {
    return _follows.where('followingId', isEqualTo: uid).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data()['followerId'] as String)
              .toList(),
        );
  }
}

final followServiceProvider = Provider<FollowService>((ref) => FollowService());
