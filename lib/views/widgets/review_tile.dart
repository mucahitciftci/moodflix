import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../models/movie_model.dart';
import '../../models/review_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/review_viewmodel.dart';
import 'comment_tile.dart';

/// A single review row: which movie it's about, author, star rating, text,
/// a like button + count, a comments toggle + count (with an inline
/// expandable comment thread + composer), and (only for the review's own
/// author) a delete button. The whole card is tappable and jumps to that
/// movie's detail page — skipped via [showMovieTitle] when the review is
/// already shown on that exact movie's own detail page, where jumping to
/// itself wouldn't make sense.
class ReviewTile extends ConsumerStatefulWidget {
  const ReviewTile({
    super.key,
    required this.review,
    this.showMovieTitle = true,
  });

  final ReviewModel review;
  final bool showMovieTitle;

  @override
  ConsumerState<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends ConsumerState<ReviewTile> {
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _requireLogin(VoidCallback action) {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      Navigator.of(context).pushNamed(AppRoutes.login);
      return;
    }
    action();
  }

  void _submitComment(String reviewId) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    _requireLogin(() {
      ref.read(commentViewModelProvider.notifier).addComment(reviewId, text);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final review = widget.review;
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final isOwner = currentUser != null && currentUser.uid == review.userId;
    final canOpenMovie = widget.showMovieTitle && review.movieTitle.isNotEmpty;

    final isLiked = ref.watch(isReviewLikedByMeProvider(review.id)).valueOrNull ?? false;
    final likeCount = ref.watch(reviewLikeCountProvider(review.id)).valueOrNull ?? 0;
    final commentsAsync = ref.watch(reviewCommentsProvider(review.id));
    final commentCount = commentsAsync.valueOrNull?.length ?? 0;

    final content = Padding(
      padding: const EdgeInsets.all(AppDimens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (canOpenMovie) ...[
            Text(
              review.movieTitle,
              style: AppTextStyles.bodyStrong.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimens.spaceXs),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  review.authorDisplayName,
                  style: AppTextStyles.bodyStrong,
                ),
              ),
              const Icon(
                Icons.star_rounded,
                size: AppDimens.iconS,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(review.rating.toStringAsFixed(0)),
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.removeFromListTooltip,
                  onPressed: () => ref
                      .read(reviewViewModelProvider.notifier)
                      .deleteReview(review.id),
                ),
            ],
          ),
          Text(review.text, style: AppTextStyles.body),
          const SizedBox(height: AppDimens.spaceXs),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isLiked ? AppColors.primary : null,
                ),
                tooltip: l10n.likeTooltip,
                onPressed: () => _requireLogin(
                  () => ref
                      .read(reviewLikeViewModelProvider.notifier)
                      .toggleLike(review.id, currentlyLiked: isLiked),
                ),
              ),
              Text('$likeCount'),
              const SizedBox(width: AppDimens.spaceM),
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined),
                tooltip: l10n.commentsTooltip,
                onPressed: () => setState(() => _showComments = !_showComments),
              ),
              Text('$commentCount'),
            ],
          ),
          if (_showComments) ...[
            const Divider(height: AppDimens.spaceM),
            commentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(l10n.errorGeneric),
              data: (comments) {
                if (comments.isEmpty) {
                  return Text(l10n.noCommentsYet, style: AppTextStyles.body);
                }
                return Column(
                  children: [
                    for (final comment in comments)
                      CommentTile(reviewId: review.id, comment: comment),
                  ],
                );
              },
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(hintText: l10n.commentHint),
                    onSubmitted: (_) => _submitComment(review.id),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () => _submitComment(review.id),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceS),
      clipBehavior: Clip.antiAlias,
      child: canOpenMovie
          ? InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                AppRoutes.movieDetail,
                arguments: MovieModel(
                  id: review.movieId,
                  title: review.movieTitle,
                  posterPath: review.moviePosterPath,
                ),
              ),
              child: content,
            )
          : content,
    );
  }
}
