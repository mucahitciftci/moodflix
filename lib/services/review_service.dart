import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> addReview(ReviewModel review) {
    return _reviews.add(review.toFirestore());
  }

  Future<void> deleteReview(String reviewId) {
    return _reviews.doc(reviewId).delete();
  }
}

final reviewServiceProvider = Provider<ReviewService>((ref) => ReviewService());
