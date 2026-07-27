import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/genre_config.dart';
import '../../core/localization/genre_localizer.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../models/discovery_source.dart';
import '../../viewmodels/movie_discovery_viewmodel.dart';

/// Lists every TMDB genre (`GenreConfig`) so the user can browse movies by
/// category instead of by mood. Tapping a genre behaves exactly like
/// tapping a mood chip: it kicks off `MovieDiscoveryViewModel.load` with a
/// `GenreSource`, then pushes the same `DiscoveryScreen`.
class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categorySelectionTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            iconSize: AppDimens.iconXl,
            tooltip: l10n.myListsScreenTitle,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.watchlist),
          ),
          const SizedBox(width: AppDimens.spaceS),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        itemCount: GenreConfig.genres.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceS),
        itemBuilder: (context, index) {
          final genre = GenreConfig.genres[index];
          return Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.local_movies_outlined),
              title: Text(l10n.genreName(genre.nameKey)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                final source = GenreSource(genre.id);
                ref.read(movieDiscoveryViewModelProvider.notifier).load(source);
                Navigator.of(context).pushNamed(
                  AppRoutes.discovery,
                  arguments: source,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
