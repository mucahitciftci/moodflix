// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Moodflix';

  @override
  String get moodMindBenderTitle => 'Mind Bender';

  @override
  String get moodNostalgiaTitle => 'Nostalgia';

  @override
  String get moodThrillerTitle => 'Thriller';

  @override
  String get moodNetflixTitle => 'Netflix Movies';

  @override
  String get emptyMovies => 'No movies found for this mood.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get myListsScreenTitle => 'My Lists';

  @override
  String get watchlistTabLabel => 'Watchlist';

  @override
  String get favoritesTabLabel => 'Favorites';

  @override
  String get emptyWatchlist =>
      'You haven\'t added anything to your watchlist yet.';

  @override
  String get emptyFavorites => 'You haven\'t added any favorites yet.';

  @override
  String get removeFromListTooltip => 'Remove';

  @override
  String get addToFavoritesTooltip => 'Add to favorites';

  @override
  String get removeFromFavoritesTooltip => 'Remove from favorites';

  @override
  String get shareTooltip => 'Send to a friend';

  @override
  String shareMessage(String title, String url) {
    return 'Check out $title: $url';
  }

  @override
  String get trailerSectionTitle => 'Trailer';

  @override
  String get trailerRequiresInternet =>
      'You need an internet connection to watch the trailer.';

  @override
  String get trailerUnavailable => 'No trailer available for this movie.';

  @override
  String get howToBrowseTitle => 'How would you like to find movies?';

  @override
  String get browseByMoodLabel => 'By Mood';

  @override
  String get browseByMoodSubtitle => 'Get picks that match how you feel';

  @override
  String get browseByCategoryLabel => 'By Category';

  @override
  String get browseByCategorySubtitle =>
      'Pick a genre and browse everything in it';

  @override
  String get moodSelectionTitle => 'Choose a Mood';

  @override
  String get categorySelectionTitle => 'Categories';

  @override
  String get genreAction => 'Action';

  @override
  String get genreAdventure => 'Adventure';

  @override
  String get genreAnimation => 'Animation';

  @override
  String get genreComedy => 'Comedy';

  @override
  String get genreCrime => 'Crime';

  @override
  String get genreDocumentary => 'Documentary';

  @override
  String get genreDrama => 'Drama';

  @override
  String get genreFamily => 'Family';

  @override
  String get genreFantasy => 'Fantasy';

  @override
  String get genreHistory => 'History';

  @override
  String get genreHorror => 'Horror';

  @override
  String get genreMusic => 'Music';

  @override
  String get genreMystery => 'Mystery';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreScienceFiction => 'Science Fiction';

  @override
  String get genreTvMovie => 'TV Movie';

  @override
  String get genreThriller => 'Thriller';

  @override
  String get genreWar => 'War';

  @override
  String get genreWestern => 'Western';

  @override
  String get searchHint => 'Search for a movie...';

  @override
  String get searchPrompt => 'Start typing a movie name';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get homeTooltip => 'Back to home';

  @override
  String get undoSwipeTooltip => 'Undo';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get themeSectionTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageTr => 'Turkish';

  @override
  String get languageEn => 'English';
}
