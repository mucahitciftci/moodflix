import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/constants/mood_config.dart';
import '../../core/localization/l10n/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../models/discovery_source.dart';
import '../../viewmodels/movie_discovery_viewmodel.dart';
import '../widgets/mood_chip.dart';

/// Reached from `BrowseModeScreen`'s "By Mood" option: pick a mood, which
/// decides which TMDB `/discover/movie` filters the discovery screen uses.
class MoodSelectionScreen extends ConsumerWidget {
  const MoodSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moodSelectionTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppDimens.moodGridCrossAxisCount,
            mainAxisSpacing: AppDimens.spaceM,
            crossAxisSpacing: AppDimens.spaceM,
            childAspectRatio: AppDimens.moodGridAspectRatio,
          ),
          itemCount: MoodConfig.moods.length,
          itemBuilder: (context, index) {
            final mood = MoodConfig.moods[index];
            return MoodChip(
              mood: mood,
              onTap: () {
                final source = MoodSource(mood.id);
                ref.read(movieDiscoveryViewModelProvider.notifier).load(source);
                Navigator.of(context).pushNamed(
                  AppRoutes.discovery,
                  arguments: source,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
