import 'package:flutter/material.dart';

import '../../models/mood_model.dart';
import 'app_colors.dart';

/// Single source of truth for every mood shown on the mood-selection screen
/// and the TMDB `/discover/movie` query parameters it maps to. Adding a new
/// mood means adding one entry here — nothing else should hardcode mood
/// data (genre ids, colors, icons, keywords).
abstract final class MoodConfig {
  static const List<MoodModel> moods = [
    MoodModel(
      id: 'mind_bender',
      titleKey: 'mood_mind_bender_title',
      icon: Icons.psychology_alt_outlined,
      color: AppColors.moodMindBender,
      discoverQueryParams: {
        'with_genres': '878,9648,53',
        'sort_by': 'vote_average.desc',
        'vote_count.gte': '200',
      },
    ),
    MoodModel(
      id: 'nostalgia',
      titleKey: 'mood_nostalgia_title',
      icon: Icons.watch_later_outlined,
      color: AppColors.moodNostalgia,
      discoverQueryParams: {
        'with_genres': '18,10751,12',
        'primary_release_date.lte': '2005-12-31',
        'sort_by': 'popularity.desc',
        'vote_count.gte': '100',
      },
    ),
    MoodModel(
      id: 'thriller',
      titleKey: 'mood_thriller_title',
      icon: Icons.bolt_outlined,
      color: AppColors.moodThriller,
      discoverQueryParams: {
        'with_genres': '53,27',
        'sort_by': 'popularity.desc',
        'vote_count.gte': '150',
      },
    ),
    MoodModel(
      id: 'netflix',
      titleKey: 'mood_netflix_title',
      icon: Icons.live_tv_outlined,
      color: AppColors.moodNetflix,
      discoverQueryParams: {
        'with_watch_providers': '8',
        'watch_region': 'TR',
        'sort_by': 'popularity.desc',
      },
    ),
  ];

  static MoodModel byId(String id) =>
      moods.firstWhere((mood) => mood.id == id, orElse: () => moods.first);
}
