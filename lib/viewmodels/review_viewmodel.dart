import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_model.dart';
import '../models/review_model.dart';
import '../repositories/review_repository.dart';
import 'auth_viewmodel.dart';

/// Live reviews for one movie — a Firestore listener, not a one-off fetch,
/// so new reviews from anyone appear without a manual refresh.
final movieReviewsProvider =
    StreamProvider.family<List<ReviewModel>, int>((ref, movieId) {
  return ref.watch(reviewRepositoryProvider).watchReviewsForMovie(movieId);
});

/// All reviews written by one user, newest first — powers `UserProfileScreen`.
final userReviewsProvider =
    StreamProvider.family<List<ReviewModel>, String>((ref, userId) {
  return ref.watch(reviewRepositoryProvider).watchReviewsByUser(userId);
});

/// Submit / delete review actions. Requires [authStateProvider] to have a
/// signed-in user — the UI is expected to gate on that before ever calling
/// [submitReview] (see `MovieDetailScreen`'s write-review button).
class ReviewViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submitReview({
    required int movieId,
    required String movieTitle,
    String? moviePosterPath,
    required double rating,
    required String text,
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final review = ReviewModel(
        id: '',
        movieId: movieId,
        movieTitle: movieTitle,
        moviePosterPath: moviePosterPath,
        userId: user.uid,
        authorDisplayName: (user.displayName?.isNotEmpty ?? false)
            ? user.displayName!
            : (user.email ?? ''),
        rating: rating,
        text: text,
        createdAt: DateTime.now(),
      );
      return ref.read(reviewRepositoryProvider).addReview(review);
    });
  }

  Future<void> deleteReview(String reviewId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(reviewRepositoryProvider).deleteReview(reviewId),
    );
  }
}

final reviewViewModelProvider = AsyncNotifierProvider<ReviewViewModel, void>(
  ReviewViewModel.new,
);

/// Whether the signed-in user has liked a review. False (not a stream of
/// false) when signed out.
final isReviewLikedByMeProvider = StreamProvider.family<bool, String>((ref, reviewId) {
  final me = ref.watch(authStateProvider).valueOrNull;
  if (me == null) return Stream.value(false);
  return ref.watch(reviewRepositoryProvider).watchIsLiked(reviewId, me.uid);
});

final reviewLikeCountProvider = StreamProvider.family<int, String>((ref, reviewId) {
  return ref.watch(reviewRepositoryProvider).watchLikeCount(reviewId);
});

/// Like / unlike actions, always as the signed-in user.
class ReviewLikeViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggleLike(String reviewId, {required bool currentlyLiked}) async {
    final me = ref.read(authStateProvider).valueOrNull;
    if (me == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(reviewRepositoryProvider);
      return currentlyLiked
          ? repo.unlikeReview(reviewId, me.uid)
          : repo.likeReview(reviewId, me.uid);
    });
  }
}

final reviewLikeViewModelProvider =
    AsyncNotifierProvider<ReviewLikeViewModel, void>(ReviewLikeViewModel.new);

/// Comments on one review, oldest first (chat-like).
final reviewCommentsProvider =
    StreamProvider.family<List<CommentModel>, String>((ref, reviewId) {
  return ref.watch(reviewRepositoryProvider).watchComments(reviewId);
});

/// Add / delete comment actions.
class CommentViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addComment(String reviewId, String text) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final comment = CommentModel(
        id: '',
        userId: user.uid,
        authorDisplayName: (user.displayName?.isNotEmpty ?? false)
            ? user.displayName!
            : (user.email ?? ''),
        text: text,
        createdAt: DateTime.now(),
      );
      return ref.read(reviewRepositoryProvider).addComment(reviewId, comment);
    });
  }

  Future<void> deleteComment(String reviewId, String commentId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(reviewRepositoryProvider).deleteComment(reviewId, commentId),
    );
  }
}

final commentViewModelProvider = AsyncNotifierProvider<CommentViewModel, void>(
  CommentViewModel.new,
);
