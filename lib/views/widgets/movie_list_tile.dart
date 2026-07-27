import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/routing/app_router.dart';
import '../../models/movie_model.dart';
import 'movie_category_badges.dart';

/// Shared movie row layout: poster thumbnail, title, rating, category
/// badges, and an optional [trailing] widget. Used by search results and
/// (via `SavedMovieTile`) the watchlist/favorites screen. Defaults to
/// navigating to the detail screen on tap.
class MovieListTile extends StatelessWidget {
  const MovieListTile({
    super.key,
    required this.movie,
    this.trailing,
    this.onTap,
  });

  final MovieModel movie;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap ??
          () => Navigator.of(context).pushNamed(
                AppRoutes.movieDetail,
                arguments: movie,
              ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        child: CachedNetworkImage(
          imageUrl: ApiConstants.posterUrl(
            movie.posterPath,
            size: ApiConstants.posterSizeSmall,
          ),
          width: AppDimens.listPosterWidth,
          height: AppDimens.listPosterWidth / AppDimens.posterAspectRatio,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const ColoredBox(color: AppColors.secondary),
          errorWidget: (context, url, error) =>
              const ColoredBox(color: AppColors.secondary),
        ),
      ),
      title: Text(movie.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: AppDimens.iconS),
              const SizedBox(width: AppDimens.spaceXs),
              Text(movie.voteAverage.toStringAsFixed(1)),
            ],
          ),
          if (movie.genreIds.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceXs),
            MovieCategoryBadges(genreIds: movie.genreIds),
          ],
        ],
      ),
      trailing: trailing,
    );
  }
}
