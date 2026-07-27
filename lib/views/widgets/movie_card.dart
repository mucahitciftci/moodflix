import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/movie_model.dart';
import 'movie_category_badges.dart';

/// A single movie's poster card, used inside [SwipeableCardStack]. Renders
/// the poster full-bleed with a bottom gradient carrying the title and
/// rating, so the text stays legible over any poster art.
class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: AppDimens.elevationM,
            offset: const Offset(0, AppDimens.elevationS),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: ApiConstants.posterUrl(
                movie.posterPath,
                size: ApiConstants.posterSizeLarge,
              ),
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const ColoredBox(color: AppColors.secondary),
              errorWidget: (context, url, error) =>
                  const ColoredBox(color: AppColors.secondary),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(AppDimens.spaceM),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.transparent, AppColors.secondary],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      style: AppTextStyles.headline.copyWith(
                        color: AppColors.onColorSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: AppDimens.iconS,
                          color: AppColors.onColorSurface,
                        ),
                        const SizedBox(width: AppDimens.spaceXs),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: AppTextStyles.bodyStrong.copyWith(
                            color: AppColors.onColorSurface,
                          ),
                        ),
                      ],
                    ),
                    if (movie.genreIds.isNotEmpty) ...[
                      const SizedBox(height: AppDimens.spaceXs),
                      MovieCategoryBadges(genreIds: movie.genreIds),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
