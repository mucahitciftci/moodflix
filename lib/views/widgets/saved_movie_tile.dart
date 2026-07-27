import 'package:flutter/material.dart';

import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../models/movie_model.dart';
import 'movie_list_tile.dart';

/// A single row on the watchlist/favorites screen: the shared
/// [MovieListTile] plus a button to remove it from that list.
class SavedMovieTile extends StatelessWidget {
  const SavedMovieTile({
    super.key,
    required this.movie,
    required this.onRemove,
  });

  final MovieModel movie;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MovieListTile(
      movie: movie,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: l10n.removeFromListTooltip,
        onPressed: onRemove,
      ),
    );
  }
}
