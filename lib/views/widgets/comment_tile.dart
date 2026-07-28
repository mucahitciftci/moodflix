import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../models/comment_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/review_viewmodel.dart';

/// A single comment row under a review — author, text, and (only for the
/// comment's own author) a small delete button.
class CommentTile extends ConsumerWidget {
  const CommentTile({super.key, required this.reviewId, required this.comment});

  final String reviewId;
  final CommentModel comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final isOwner = currentUser != null && currentUser.uid == comment.userId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.body.copyWith(color: DefaultTextStyle.of(context).style.color),
                children: [
                  TextSpan(
                    text: '${comment.authorDisplayName}  ',
                    style: AppTextStyles.bodyStrong,
                  ),
                  TextSpan(text: comment.text),
                ],
              ),
            ),
          ),
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: AppDimens.iconS),
              tooltip: l10n.removeFromListTooltip,
              onPressed: () => ref
                  .read(commentViewModelProvider.notifier)
                  .deleteComment(reviewId, comment.id),
            ),
        ],
      ),
    );
  }
}
