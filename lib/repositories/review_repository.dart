import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_model.dart';
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

  Stream<List<ReviewModel>> watchReviewsByUser(String userId) =>
      _reviewService.watchReviewsByUser(userId);

  Future<void> addReview(ReviewModel review) =>
      _reviewService.addReview(review);

  Future<void> deleteReview(String reviewId) =>
      _reviewService.deleteReview(reviewId);

  Future<void> likeReview(String reviewId, String userId) =>
      _reviewService.likeReview(reviewId, userId);

  Future<void> unlikeReview(String reviewId, String userId) =>
      _reviewService.unlikeReview(reviewId, userId);

  Stream<bool> watchIsLiked(String reviewId, String userId) =>
      _reviewService.watchIsLiked(reviewId, userId);

  Stream<int> watchLikeCount(String reviewId) =>
      _reviewService.watchLikeCount(reviewId);

  Stream<List<CommentModel>> watchComments(String reviewId) =>
      _reviewService.watchComments(reviewId);

  Future<void> addComment(String reviewId, CommentModel comment) =>
      _reviewService.addComment(reviewId, comment);

  Future<void> deleteComment(String reviewId, String commentId) =>
      _reviewService.deleteComment(reviewId, commentId);
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(reviewService: ref.watch(reviewServiceProvider));
});
