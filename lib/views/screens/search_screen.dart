import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../viewmodels/movie_search_viewmodel.dart';
import '../widgets/app_bar_home_leading.dart';
import '../widgets/movie_list_tile.dart';

/// Free-text movie search, reached by tapping the search bar on
/// `BrowseModeScreen`. Results use the shared `MovieListTile`, which
/// navigates straight to `MovieDetailScreen` on tap — matching the request
/// to type a title and land directly on that movie's page.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resultsAsync = ref.watch(movieSearchViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppDimens.appBarLeadingWidthWide,
        leading: const AppBarHomeLeading(),
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: AppTextStyles.body.copyWith(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
          onChanged: (query) =>
              ref.read(movieSearchViewModelProvider.notifier).search(query),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.errorGeneric)),
        data: (results) {
          if (_controller.text.trim().isEmpty) {
            return Center(child: Text(l10n.searchPrompt));
          }
          if (results.isEmpty) {
            return Center(child: Text(l10n.searchNoResults));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            itemCount: results.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceS),
            itemBuilder: (context, index) =>
                MovieListTile(movie: results[index]),
          );
        },
      ),
    );
  }
}
