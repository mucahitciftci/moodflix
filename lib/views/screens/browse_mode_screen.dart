import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../models/discovery_source.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/movie_discovery_viewmodel.dart';
import '../widgets/chameleon_mascot.dart';

const double _mascotSize = AppDimens.iconXl * 2;

/// The app's true home screen: lets the user pick how they want to find
/// movies — by mood (`MoodSelectionScreen`) or by category
/// (`CategorySelectionScreen`) — before anything TMDB-related loads.
class BrowseModeScreen extends ConsumerWidget {
  const BrowseModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final displayName = ref.watch(authStateProvider).valueOrNull?.displayName;
    final browseTitle = (displayName != null && displayName.isNotEmpty)
        ? l10n.howToBrowseTitleWithName(displayName)
        : l10n.howToBrowseTitle;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppDimens.appBarHeightLarge,
        titleTextStyle: AppTextStyles.displayLarge.copyWith(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups_outlined),
            iconSize: AppDimens.iconXl,
            tooltip: l10n.socialScreenTitle,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.social),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            iconSize: AppDimens.iconXl,
            tooltip: l10n.myListsScreenTitle,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.watchlist),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            iconSize: AppDimens.iconXl,
            tooltip: l10n.settingsScreenTitle,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
          const SizedBox(width: AppDimens.spaceS),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _SearchBarEntry(
                  hint: l10n.searchHint,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.search),
                ),
                Positioned(
                  top: -_mascotSize * 0.5,
                  right: AppDimens.spaceS,
                  child: const IgnorePointer(
                    child: Opacity(
                      opacity: 0.8,
                      child: ChameleonMascot(size: _mascotSize, bare: true),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceXl),
            Text(
              browseTitle,
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceL),
            _BrowseModeCard(
              icon: Icons.mood_outlined,
              label: l10n.browseByMoodLabel,
              subtitle: l10n.browseByMoodSubtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.moodSelection),
            ),
            const SizedBox(height: AppDimens.spaceM),
            _BrowseModeCard(
              icon: Icons.category_outlined,
              label: l10n.browseByCategoryLabel,
              subtitle: l10n.browseByCategorySubtitle,
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.categorySelection),
            ),
            const SizedBox(height: AppDimens.spaceM),
            _BrowseModeCard(
              icon: Icons.trending_up_rounded,
              label: l10n.browseByTrendingLabel,
              subtitle: l10n.browseByTrendingSubtitle,
              onTap: () {
                const source = TrendingSource();
                ref.read(movieDiscoveryViewModelProvider.notifier).load(source);
                Navigator.of(context)
                    .pushNamed(AppRoutes.discovery, arguments: source);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Large, tappable search-bar look-alike. Tapping it (rather than typing
/// directly here) pushes `SearchScreen`, where the real `TextField` lives
/// with autofocus — keeps this screen simple and gives the keyboard a
/// dedicated screen to open into.
class _SearchBarEntry extends StatelessWidget {
  const _SearchBarEntry({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceL,
            vertical: AppDimens.spaceM,
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: AppDimens.iconL),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                child: Text(hint, style: AppTextStyles.body),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrowseModeCard extends StatelessWidget {
  const _BrowseModeCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        onTap: onTap,
        child: Container(
          height: AppDimens.browseModeCardHeight,
          padding: const EdgeInsets.all(AppDimens.spaceM),
          child: Row(
            children: [
              Icon(icon, size: AppDimens.iconXl, color: AppColors.onColorSurface),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.headline.copyWith(
                        color: AppColors.onColorSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Text(
                      subtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onColorSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: AppDimens.iconL,
                color: AppColors.onColorSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
