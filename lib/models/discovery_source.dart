import 'package:flutter/foundation.dart';

import '../core/constants/genre_config.dart';
import '../core/constants/mood_config.dart';

/// What the discovery screen is currently browsing: either a mood
/// (`MoodConfig`) or a genre (`GenreConfig`). Both resolve to the same
/// shape — a cache key and TMDB `/discover/movie` query params — so
/// [MovieRepository] and [MovieDiscoveryViewModel] stay generic over
/// either, instead of needing a parallel implementation per browsing mode.
@immutable
sealed class DiscoverySource {
  const DiscoverySource();

  /// Cache/pagination key. Prefixed per subtype so a mood and a genre can
  /// never collide in the discovery page cache.
  String get cacheKey;

  Map<String, String> get queryParams;
}

class MoodSource extends DiscoverySource {
  final String moodId;

  const MoodSource(this.moodId);

  @override
  String get cacheKey => 'mood_$moodId';

  @override
  Map<String, String> get queryParams => MoodConfig.byId(moodId).discoverQueryParams;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MoodSource && other.moodId == moodId);

  @override
  int get hashCode => moodId.hashCode;
}

class GenreSource extends DiscoverySource {
  final int genreId;

  const GenreSource(this.genreId);

  @override
  String get cacheKey => 'genre_$genreId';

  @override
  Map<String, String> get queryParams => GenreConfig.discoverQueryParams(genreId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is GenreSource && other.genreId == genreId);

  @override
  int get hashCode => genreId.hashCode;
}
