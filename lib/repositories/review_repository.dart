import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review_model.dart';
import '../services/review_service.dart';

/// Bridges [ReviewService] (Firestore) into the [ReviewModel] data view
/// models consume. Unlike [MovieRepository], there's no local cache to
/// merge — reviews are inherently shared/live data, so this is a thin pass
/// through kept for architectural consistency (View → ViewModel →
/// Repository → Service) rather than because it does any real work yet.
class ReviewRepository {
  ReviewRepository({required ReviewService reviewService})
      : _reviewService = reviewService;

  final ReviewService _reviewService;

  Stream<List<ReviewModel>> watchReviewsForMovie(int movieId) =>
      _reviewService.watchReviewsForMovie(movieId);

  Future<void> addReview(ReviewModel review) =>
      _reviewService.addReview(review);

  Future<void> deleteReview(String reviewId) =>
      _reviewService.deleteReview(reviewId);
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(reviewService: ref.watch(reviewServiceProvider));
});
