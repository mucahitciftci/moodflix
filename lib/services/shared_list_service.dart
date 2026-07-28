import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';

/// Raw Firestore read/write for a user's *shared* watchlist/favorites —
/// `users/{uid}/watchlist` and `users/{uid}/favorites` subcollections,
/// mirroring the same movie JSON Hive stores locally. Only ever written to
/// when the owning user has turned on list sharing (see
/// `ListSharingViewModel`) — visibility to other users is enforced
/// server-side by `firestore.rules`' `canViewSharedList`, keyed off the
/// owner's `users/{uid}.listSharing` field.
class SharedListService {
  SharedListService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _watchlist(String uid) =>
      _firestore.collection('users').doc(uid).collection('watchlist');

  CollectionReference<Map<String, dynamic>> _favorites(String uid) =>
      _firestore.collection('users').doc(uid).collection('favorites');

  Future<void> setWatchlistItem(String uid, MovieModel movie) =>
      _watchlist(uid).doc('${movie.id}').set(movie.toJson());

  Future<void> removeWatchlistItem(String uid, int movieId) =>
      _watchlist(uid).doc('$movieId').delete();

  Future<void> setFavoriteItem(String uid, MovieModel movie) =>
      _favorites(uid).doc('${movie.id}').set(movie.toJson());

  Future<void> removeFavoriteItem(String uid, int movieId) =>
      _favorites(uid).doc('$movieId').delete();

  Stream<List<MovieModel>> watchSharedWatchlist(String uid) {
    return _watchlist(uid)
        .snapshots()
        .map((s) => s.docs.map((d) => MovieModel.fromJson(d.data())).toList());
  }

  Stream<List<MovieModel>> watchSharedFavorites(String uid) {
    return _favorites(uid)
        .snapshots()
        .map((s) => s.docs.map((d) => MovieModel.fromJson(d.data())).toList());
  }

  /// One-time bulk push — used when a user turns sharing ON, so everything
  /// already in their local Hive lists appears in Firestore immediately
  /// instead of only movies added/removed from that point forward.
  Future<void> syncAll({
    required String uid,
    required List<MovieModel> watchlist,
    required List<MovieModel> favorites,
  }) async {
    final batch = _firestore.batch();
    for (final movie in watchlist) {
      batch.set(_watchlist(uid).doc('${movie.id}'), movie.toJson());
    }
    for (final movie in favorites) {
      batch.set(_favorites(uid).doc('${movie.id}'), movie.toJson());
    }
    await batch.commit();
  }

  /// Wipes both mirrored subcollections — used when sharing is turned OFF,
  /// so stale data doesn't linger in Firestore even though rules would
  /// already block anyone else from reading it.
  Future<void> clearAll(String uid) async {
    final watchlistDocs = await _watchlist(uid).get();
    final favoritesDocs = await _favorites(uid).get();
    final batch = _firestore.batch();
    for (final doc in watchlistDocs.docs) {
      batch.delete(doc.reference);
    }
    for (final doc in favoritesDocs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

final sharedListServiceProvider = Provider<SharedListService>(
  (ref) => SharedListService(),
);
