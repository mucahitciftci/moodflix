import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/genre_localizer.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/localization/mood_localizer.dart';
import '../../core/utils/movie_category_matcher.dart';

/// Small colored pills showing which mood(s)/genre(s) a movie belongs to,
/// inferred from its TMDB genre IDs via [MovieCategoryMatcher]. Shown under
/// every movie listing (cards, saved lists, search results, detail screen)
/// so the category is visible regardless of how the movie was found.
/// Renders nothing if [genreIds] matches no known mood or genre.
class MovieCategoryBadges extends StatelessWidget {
  const MovieCategoryBadges({super.key, required this.genreIds});

  final List<int> genreIds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final moods = MovieCategoryMatcher.matchingMoods(genreIds);
    final genres = MovieCategoryMatcher.matchingGenres(genreIds);

    if (moods.isEmpty && genres.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppDimens.spaceXs,
      runSpacing: AppDimens.spaceXs,
      children: [
        for (final mood in moods)
          _Badge(label: l10n.moodTitle(mood.titleKey), color: mood.color),
        for (final genre in genres)
          _Badge(label: l10n.genreName(genre.nameKey), color: AppColors.secondary),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceS,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.onColorSurface),
      ),
    );
  }
}
