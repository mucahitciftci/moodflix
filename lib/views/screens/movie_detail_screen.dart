import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../models/movie_model.dart';
import '../../services/connectivity_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../../viewmodels/movie_detail_viewmodel.dart';
import '../../viewmodels/review_viewmodel.dart';
import '../widgets/app_bar_home_leading.dart';
import '../widgets/movie_category_badges.dart';
import '../widgets/review_composer_sheet.dart';
import '../widgets/review_tile.dart';

/// Movie detail screen: poster, rating, overview, trailer (YouTube, live
/// connectivity required), favorite toggle and share. [movie] is the data
/// already known from wherever the user tapped in (a card or a saved-list
/// row); [MovieDetailViewModel] fills in the trailer key in the background.
class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(favoritesViewModelProvider);
    final isFavorite = favorites.any((m) => m.id == movie.id);
    final detailAsync = ref.watch(movieDetailViewModelProvider(movie.id));
    final trailerKey =
        detailAsync.valueOrNull?.trailerYoutubeKey ?? movie.trailerYoutubeKey;
    final overview = detailAsync.valueOrNull?.overview ?? movie.overview;
    final detailGenreIds = detailAsync.valueOrNull?.genreIds ?? const [];
    final genreIds = detailGenreIds.isNotEmpty ? detailGenreIds : movie.genreIds;
    final reviewsAsync = ref.watch(movieReviewsProvider(movie.id));

    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppDimens.appBarLeadingWidthWide,
        leading: const AppBarHomeLeading(),
        title: Text(movie.title),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            tooltip: isFavorite
                ? l10n.removeFromFavoritesTooltip
                : l10n.addToFavoritesTooltip,
            onPressed: () {
              final notifier = ref.read(favoritesViewModelProvider.notifier);
              if (isFavorite) {
                notifier.remove(movie.id);
              } else {
                notifier.add(movie);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: l10n.shareTooltip,
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: l10n.shareMessage(
                  movie.title,
                  ApiConstants.movieWebUrl(movie.id),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: AppDimens.backdropAspectRatio,
              child: CachedNetworkImage(
                imageUrl: movie.backdropPath != null
                    ? ApiConstants.backdropUrl(movie.backdropPath)
                    : ApiConstants.posterUrl(
                        movie.posterPath,
                        size: ApiConstants.posterSizeLarge,
                      ),
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ColoredBox(color: AppColors.secondary),
                errorWidget: (context, url, error) =>
                    const ColoredBox(color: AppColors.secondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: AppDimens.iconM),
                      const SizedBox(width: AppDimens.spaceXs),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: AppTextStyles.bodyStrong,
                      ),
                    ],
                  ),
                  if (genreIds.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spaceS),
                    MovieCategoryBadges(genreIds: genreIds),
                  ],
                  const SizedBox(height: AppDimens.spaceM),
                  if (overview != null && overview.isNotEmpty)
                    Text(overview, style: AppTextStyles.body),
                  const SizedBox(height: AppDimens.spaceL),
                  Text(l10n.trailerSectionTitle, style: AppTextStyles.title),
                  const SizedBox(height: AppDimens.spaceS),
                  _TrailerSection(
                    trailerKey: trailerKey,
                    isLoadingDetails: detailAsync.isLoading,
                  ),
                  const SizedBox(height: AppDimens.spaceL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.reviewsSectionTitle, style: AppTextStyles.title),
                      TextButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(l10n.writeReviewLabel),
                        onPressed: () {
                          final user = ref.read(authStateProvider).valueOrNull;
                          if (user == null) {
                            Navigator.of(context).pushNamed(AppRoutes.login);
                            return;
                          }
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => ReviewComposerSheet(
                              movieId: movie.id,
                              movieTitle: movie.title,
                              moviePosterPath: movie.posterPath,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  reviewsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text(l10n.errorGeneric),
                    data: (reviews) {
                      if (reviews.isEmpty) {
                        return Text(l10n.noReviewsYet, style: AppTextStyles.body);
                      }
                      return Column(
                        children: [
                          for (final review in reviews)
                            ReviewTile(review: review, showMovieTitle: false),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders the trailer player once a [trailerKey] is available. Owns the
/// [YoutubePlayerController] lifecycle itself (created when the key first
/// appears, recreated if it changes, closed on dispose) rather than
/// building a fresh controller on every rebuild.
class _TrailerSection extends ConsumerStatefulWidget {
  const _TrailerSection({
    required this.trailerKey,
    required this.isLoadingDetails,
  });

  final String? trailerKey;
  final bool isLoadingDetails;

  @override
  ConsumerState<_TrailerSection> createState() => _TrailerSectionState();
}

class _TrailerSectionState extends ConsumerState<_TrailerSection> {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;

  @override
  void didUpdateWidget(covariant _TrailerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trailerKey != widget.trailerKey) {
      _controller?.close();
      _controller = null;
      _isPlaying = false;
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  /// Creates the live controller — and with it, the embedded iframe — only
  /// once the user actually taps play. Mounting the iframe immediately (and
  /// keeping it mounted inside a `SingleChildScrollView`) makes scrolling
  /// visibly janky on web, since the platform view has to be repositioned
  /// on every scroll frame; a static thumbnail avoids that until playback
  /// is actually wanted.
  void _startPlaying() {
    final key = widget.trailerKey;
    if (key == null || key.isEmpty) return;
    setState(() {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: key,
        autoPlay: true,
      );
      _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isOnline = ref.watch(connectivityStatusProvider).valueOrNull ?? true;

    if (!isOnline) {
      return _TrailerMessage(
        icon: Icons.wifi_off_rounded,
        message: l10n.trailerRequiresInternet,
      );
    }

    if (widget.isLoadingDetails) {
      return const AspectRatio(
        aspectRatio: AppDimens.backdropAspectRatio,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final key = widget.trailerKey;
    if (key == null || key.isEmpty) {
      return _TrailerMessage(
        icon: Icons.movie_filter_outlined,
        message: l10n.trailerUnavailable,
      );
    }

    final controller = _controller;
    if (_isPlaying && controller != null) {
      return YoutubePlayer(
        controller: controller,
        aspectRatio: AppDimens.backdropAspectRatio,
      );
    }

    return _TrailerThumbnail(videoId: key, onTap: _startPlaying);
  }
}

/// Static YouTube thumbnail with a play affordance. Tapping it is what
/// mounts the real (heavier) [YoutubePlayer] — see [_startPlaying].
class _TrailerThumbnail extends StatelessWidget {
  const _TrailerThumbnail({required this.videoId, required this.onTap});

  final String videoId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppDimens.backdropAspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: ApiConstants.youtubeThumbnailFor(videoId),
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const ColoredBox(color: AppColors.secondary),
              errorWidget: (context, url, error) =>
                  const ColoredBox(color: AppColors.secondary),
            ),
            Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppDimens.spaceM),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.onColorSurface,
                      size: AppDimens.iconL,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrailerMessage extends StatelessWidget {
  const _TrailerMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppDimens.backdropAspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppDimens.iconL),
              const SizedBox(height: AppDimens.spaceS),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
