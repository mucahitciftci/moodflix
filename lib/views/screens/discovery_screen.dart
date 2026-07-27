import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/genre_config.dart';
import '../../core/constants/mood_config.dart';
import '../../core/localization/genre_localizer.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/localization/mood_localizer.dart';
import '../../models/discovery_source.dart';
import '../../viewmodels/movie_discovery_viewmodel.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../widgets/app_bar_home_leading.dart';
import '../widgets/swipeable_card_stack.dart';

/// Discovery screen for the [DiscoverySource] (a mood or a genre) selected
/// on `MoodSelectionScreen`/`CategorySelectionScreen`. Renders a swipeable
/// card stack: swipe right adds to the watchlist, swipe left skips.
/// Pagination is driven by the stack running low on cards rather than
/// scroll position, since there's no scrollable list here.
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key, required this.source});

  final DiscoverySource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = switch (source) {
      MoodSource(:final moodId) => l10n.moodTitle(MoodConfig.byId(moodId).titleKey),
      GenreSource(:final genreId) => l10n.genreName(GenreConfig.byId(genreId).nameKey),
    };
    final discoveryState = ref.watch(movieDiscoveryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppDimens.appBarLeadingWidthWide,
        leading: const AppBarHomeLeading(),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        child: discoveryState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(l10n.errorGeneric)),
          data: (state) {
            if (state.movies.isEmpty) {
              return Center(child: Text(l10n.emptyMovies));
            }
            return SwipeableCardStack(
              key: ValueKey(source.cacheKey),
              movies: state.movies,
              onSwipeRight: (movie) =>
                  ref.read(watchlistViewModelProvider.notifier).add(movie),
              onSwipeLeft: (_) {},
              onUndoSwipe: (movie, wasSwipeRight) {
                if (wasSwipeRight) {
                  ref.read(watchlistViewModelProvider.notifier).remove(movie.id);
                }
              },
              onStackRunningLow: () => ref
                  .read(movieDiscoveryViewModelProvider.notifier)
                  .loadNextPage(),
            );
          },
        ),
      ),
    );
  }
}
