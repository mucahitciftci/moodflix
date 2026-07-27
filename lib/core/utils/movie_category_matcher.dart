import '../../models/genre_model.dart';
import '../../models/mood_model.dart';
import '../constants/genre_config.dart';
import '../constants/mood_config.dart';

/// Infers which moods/genres a movie "belongs to" purely from its TMDB
/// [MovieModel.genreIds] — works for any movie regardless of how it was
/// found (swipe, search, saved list), unlike a per-save record of "which
/// mood you added it under".
abstract final class MovieCategoryMatcher {
  static List<MoodModel> matchingMoods(List<int> genreIds) {
    return MoodConfig.moods
        .where((mood) => _moodGenreIds(mood).any(genreIds.contains))
        .toList();
  }

  static List<GenreModel> matchingGenres(List<int> genreIds) {
    return GenreConfig.genres
        .where((genre) => genreIds.contains(genre.id))
        .toList();
  }

  /// A mood "matches" a movie if any of the genre IDs it filters by
  /// (`with_genres`) appear in the movie's own genres. Moods that don't
  /// filter by genre at all (e.g. the Netflix mood, which filters by watch
  /// provider) never match — there's no genre signal to infer from.
  static Set<int> _moodGenreIds(MoodModel mood) {
    final raw = mood.discoverQueryParams['with_genres'];
    if (raw == null || raw.isEmpty) return const {};
    return raw.split(',').map(int.parse).toSet();
  }
}
