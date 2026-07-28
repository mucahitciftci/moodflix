import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_model.dart';
import '../models/review_model.dart';

/// Raw Firestore read/write for the `reviews` collection. Write access is
/// further constrained by `firestore.rules` (must be signed in, must write
/// as yourself, reviews are immutable once posted) — this class doesn't
/// re-check any of that, it trusts the rules to enforce it server-side.
class ReviewService {
  ReviewService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _reviews =>
      _firestore.collection('reviews');

  Stream<List<ReviewModel>> watchReviewsForMovie(int movieId) {
    return _reviews
        .where('movieId', isEqualTo: movieId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  Stream<List<ReviewModel>> watchReviewsByUser(String userId) {
    return _reviews
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  Future<void> addReview(ReviewModel review) {
    return _reviews.add(review.toFirestore());
  }

  Future<void> deleteReview(String reviewId) {
    return _reviews.doc(reviewId).delete();
  }

  // --- Likes (`reviews/{reviewId}/likes/{userId}` — doc existence = liked) ---

  CollectionReference<Map<String, dynamic>> _likes(String reviewId) =>
      _reviews.doc(reviewId).collection('likes');

  Future<void> likeReview(String reviewId, String userId) {
    return _likes(reviewId).doc(userId).set({'userId': userId});
  }

  Future<void> unlikeReview(String reviewId, String userId) {
    return _likes(reviewId).doc(userId).delete();
  }

  Stream<bool> watchIsLiked(String reviewId, String userId) {
    return _likes(reviewId).doc(userId).snapshots().map((doc) => doc.exists);
  }

  /// A live count via the subcollection listener rather than a `count()`
  /// aggregation query — simpler, and fine at the like-counts-per-review
  /// scale this app operates at.
  Stream<int> watchLikeCount(String reviewId) {
    return _likes(reviewId).snapshots().map((snapshot) => snapshot.docs.length);
  }

  // --- Comments (`reviews/{reviewId}/comments`) ---

  CollectionReference<Map<String, dynamic>> _comments(String reviewId) =>
      _reviews.doc(reviewId).collection('comments');

  Stream<List<CommentModel>> watchComments(String reviewId) {
    return _comments(reviewId).orderBy('createdAt').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addComment(String reviewId, CommentModel comment) {
    return _comments(reviewId).add(comment.toFirestore());
  }

  Future<void> deleteComment(String reviewId, String commentId) {
    return _comments(reviewId).doc(commentId).delete();
  }
}

final reviewServiceProvider = Provider<ReviewService>((ref) => ReviewService());
