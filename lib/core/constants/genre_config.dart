import '../../models/genre_model.dart';

/// Every TMDB movie genre, for the category-based browsing mode (an
/// alternative to mood-based discovery). IDs are TMDB's official, stable
/// genre IDs (see https://developer.themoviedb.org/reference/genre-movie-list)
/// — hardcoded here rather than fetched from `/genre/movie/list` at runtime,
/// the same tradeoff `MoodConfig` already makes: one source of truth,
/// works offline, and keeps genre names under our own TR/EN localization
/// instead of TMDB's.
abstract final class GenreConfig {
  static const List<GenreModel> genres = [
    GenreModel(id: 28, nameKey: 'genre_action'),
    GenreModel(id: 12, nameKey: 'genre_adventure'),
    GenreModel(id: 16, nameKey: 'genre_animation'),
    GenreModel(id: 35, nameKey: 'genre_comedy'),
    GenreModel(id: 80, nameKey: 'genre_crime'),
    GenreModel(id: 99, nameKey: 'genre_documentary'),
    GenreModel(id: 18, nameKey: 'genre_drama'),
    GenreModel(id: 10751, nameKey: 'genre_family'),
    GenreModel(id: 14, nameKey: 'genre_fantasy'),
    GenreModel(id: 36, nameKey: 'genre_history'),
    GenreModel(id: 27, nameKey: 'genre_horror'),
    GenreModel(id: 10402, nameKey: 'genre_music'),
    GenreModel(id: 9648, nameKey: 'genre_mystery'),
    GenreModel(id: 10749, nameKey: 'genre_romance'),
    GenreModel(id: 878, nameKey: 'genre_science_fiction'),
    GenreModel(id: 10770, nameKey: 'genre_tv_movie'),
    GenreModel(id: 53, nameKey: 'genre_thriller'),
    GenreModel(id: 10752, nameKey: 'genre_war'),
    GenreModel(id: 37, nameKey: 'genre_western'),
  ];

  static GenreModel byId(int id) =>
      genres.firstWhere((genre) => genre.id == id, orElse: () => genres.first);

  static Map<String, String> discoverQueryParams(int genreId) => {
        'with_genres': '$genreId',
        'sort_by': 'popularity.desc',
        'vote_count.gte': '50',
      };
}
