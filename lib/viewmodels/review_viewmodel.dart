import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/review_model.dart';
import '../repositories/review_repository.dart';
import 'auth_viewmodel.dart';

/// Live reviews for one movie — a Firestore listener, not a one-off fetch,
/// so new reviews from anyone appear without a manual refresh.
final movieReviewsProvider =
    StreamProvider.family<List<ReviewModel>, int>((ref, movieId) {
  return ref.watch(reviewRepositoryProvider).watchReviewsForMovie(movieId);
});

/// Submit / delete review actions. Requires [authStateProvider] to have a
/// signed-in user — the UI is expected to gate on that before ever calling
/// [submitReview] (see `MovieDetailScreen`'s write-review button).
class ReviewViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submitReview({
    required int movieId,
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
