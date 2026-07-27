import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../models/review_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/review_viewmodel.dart';

/// A single review row on the movie detail screen: author, star rating,
/// text, and (only for the review's own author) a delete button.
class ReviewTile extends ConsumerWidget {
  const ReviewTile({super.key, required this.review});

  final ReviewModel review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final isOwner = currentUser != null && currentUser.uid == review.userId;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceS),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
    );
  }
}
