import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../models/movie_model.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../../viewmodels/watchlist_viewmodel.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/saved_movie_tile.dart';

/// Combines the user's two local movie lists — "İzleyeceklerim" (watchlist,
/// filled by swiping right on the discovery screen) and "Favorilerim"
/// (favorites, filled from the detail screen) — behind tabs. Both lists are
/// Hive-backed via their respective viewmodels, so this screen works fully
/// offline.
class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.myListsScreenTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.watchlistTabLabel),
              Tab(text: l10n.favoritesTabLabel),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_WatchlistTab(), _FavoritesTab()],
        ),
      ),
    );
  }
}

class _WatchlistTab extends ConsumerWidget {
  const _WatchlistTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final movies = ref.watch(watchlistViewModelProvider);

    return _SavedMovieList(
      movies: movies,
      emptyLabel: l10n.emptyWatchlist,
      onRemove: (id) =>
          ref.read(watchlistViewModelProvider.notifier).remove(id),
    );
  }
}

class _FavoritesTab extends ConsumerWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final movies = ref.watch(favoritesViewModelProvider);

    return _SavedMovieList(
      movies: movies,
      emptyLabel: l10n.emptyFavorites,
      onRemove: (id) =>
          ref.read(favoritesViewModelProvider.notifier).remove(id),
    );
  }
}

class _SavedMovieList extends StatelessWidget {
  const _SavedMovieList({
    required this.movies,
    required this.emptyLabel,
    required this.onRemove,
  });

  final List<MovieModel> movies;
  final String emptyLabel;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return EmptyStateView(message: emptyLabel);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimens.spaceM),
      itemCount: movies.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceS),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return SavedMovieTile(
          movie: movie,
          onRemove: () => onRemove(movie.id),
        );
      },
    );
  }
}
