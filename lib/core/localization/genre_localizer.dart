import 'l10n/generated/app_localizations.dart';

/// Resolves a [GenreModel.nameKey] (defined once in `GenreConfig`) to its
/// localized string. Mirrors `MoodLocalizer` — genre names live in the ARB
/// files, not hardcoded in the widgets that render them.
extension GenreLocalizer on AppLocalizations {
  String genreName(String nameKey) {
    switch (nameKey) {
      case 'genre_action':
        return genreAction;
      case 'genre_adventure':
        return genreAdventure;
      case 'genre_animation':
        return genreAnimation;
      case 'genre_comedy':
        return genreComedy;
      case 'genre_crime':
        return genreCrime;
      case 'genre_documentary':
        return genreDocumentary;
      case 'genre_drama':
        return genreDrama;
      case 'genre_family':
        return genreFamily;
      case 'genre_fantasy':
        return genreFantasy;
      case 'genre_history':
        return genreHistory;
      case 'genre_horror':
        return genreHorror;
      case 'genre_music':
        return genreMusic;
      case 'genre_mystery':
        return genreMystery;
      case 'genre_romance':
        return genreRomance;
      case 'genre_science_fiction':
        return genreScienceFiction;
      case 'genre_tv_movie':
        return genreTvMovie;
      case 'genre_thriller':
        return genreThriller;
      case 'genre_war':
        return genreWar;
      case 'genre_western':
        return genreWestern;
      default:
        return nameKey;
    }
  }
}
