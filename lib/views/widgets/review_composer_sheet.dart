import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../viewmodels/review_viewmodel.dart';

/// Bottom sheet for writing a review: a 1-5 star picker and a text field.
/// Shown via `showModalBottomSheet` from `MovieDetailScreen`, only once the
/// caller has already confirmed the user is signed in.
class ReviewComposerSheet extends ConsumerStatefulWidget {
  const ReviewComposerSheet({
    super.key,
    required this.movieId,
    required this.movieTitle,
    this.moviePosterPath,
  });

  final int movieId;
  final String movieTitle;
  final String? moviePosterPath;

  @override
  ConsumerState<ReviewComposerSheet> createState() =>
      _ReviewComposerSheetState();
}

class _ReviewComposerSheetState extends ConsumerState<ReviewComposerSheet> {
  final TextEditingController _textController = TextEditingController();
  int _rating = AppDimens.reviewMaxRating;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    await ref.read(reviewViewModelProvider.notifier).submitReview(
          movieId: widget.movieId,
          movieTitle: widget.movieTitle,
          moviePosterPath: widget.moviePosterPath,
          rating: _rating.toDouble(),
          text: text,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final submitState = ref.watch(reviewViewModelProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.spaceM,
        right: AppDimens.spaceM,
        top: AppDimens.spaceM,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimens.spaceM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.writeReviewTitle, style: AppTextStyles.title),
          const SizedBox(height: AppDimens.spaceS),
          Row(
            children: [
              for (var star = 1; star <= AppDimens.reviewMaxRating; star++)
                IconButton(
                  icon: Icon(
                    star <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: () => setState(() => _rating = star),
                ),
            ],
          ),
          TextField(
            controller: _textController,
            maxLines: 4,
            maxLength: AppDimens.reviewTextMaxLength,
            decoration: InputDecoration(hintText: l10n.reviewTextHint),
          ),
          const SizedBox(height: AppDimens.spaceS),
          ElevatedButton(
            onPressed: submitState.isLoading ? null : _submit,
            child: submitState.isLoading
                ? const SizedBox(
                    width: AppDimens.iconM,
                    height: AppDimens.iconM,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.submitReviewLabel),
          ),
        ],
      ),
    );
  }
}
