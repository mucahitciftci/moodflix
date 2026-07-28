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
  String get authTagline => 'Movies that match your mood';

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
  String get settingsScreenTitle => 'Menu';

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

  @override
  String get loginScreenTitle => 'Log In';

  @override
  String get signUpScreenTitle => 'Sign Up';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get displayNameLabel => 'Your name';

  @override
  String get forgotPasswordLabel => 'Forgot password?';

  @override
  String get sendResetLinkLabel => 'Send';

  @override
  String get resetLinkSentMessage => 'Password reset link sent to your email.';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get goToSignUpLabel => 'Don\'t have an account? Sign up';

  @override
  String get goToLoginLabel => 'Already have an account? Log in';

  @override
  String get authErrorGeneric =>
      'Something went wrong. Check your details and try again.';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get logoutLabel => 'Log Out';

  @override
  String get notLoggedInMessage => 'Not logged in';

  @override
  String get reviewsSectionTitle => 'Reviews';

  @override
  String get writeReviewLabel => 'Write a Review';

  @override
  String get writeReviewTitle => 'Write your review';

  @override
  String get reviewTextHint => 'What did you think of this movie?';

  @override
  String get submitReviewLabel => 'Submit';

  @override
  String get noReviewsYet => 'No reviews yet. Be the first to write one!';

  @override
  String get continueAsGuestLabel => 'Continue as guest';

  @override
  String howToBrowseTitleWithName(String name) {
    return 'How would you like to find movies, $name?';
  }

  @override
  String get changePhotoLabel => 'Change profile photo';

  @override
  String get choosePhotoFromGalleryLabel => 'Choose from gallery';

  @override
  String get takePhotoLabel => 'Take a photo';

  @override
  String get removePhotoLabel => 'Remove photo';

  @override
  String get createPresetAvatarLabel => 'Create a preset avatar';

  @override
  String get chooseAnimalLabel => 'Choose an animal';

  @override
  String get chooseColorLabel => 'Choose a color';

  @override
  String get changeUsernameLabel => 'Change Username';

  @override
  String get changeEmailLabel => 'Change Email';

  @override
  String get changePasswordLabel => 'Change Password';

  @override
  String get newEmailLabel => 'New email';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get saveLabel => 'Save';

  @override
  String get usernameUpdatedMessage => 'Your username was updated.';

  @override
  String get emailUpdateSentMessage =>
      'We sent a confirmation link to your new email. It will change once you confirm it.';

  @override
  String get passwordUpdatedMessage => 'Your password was updated.';

  @override
  String get socialScreenTitle => 'Social';

  @override
  String get searchTabLabel => 'Search';

  @override
  String get followingTabLabel => 'Following';

  @override
  String get searchUsersHint => 'Search users...';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get noFollowingYet => 'You\'re not following anyone yet';

  @override
  String get followButtonLabel => 'Follow';

  @override
  String get unfollowButtonLabel => 'Following';

  @override
  String get userHasNoReviewsYet =>
      'This user hasn\'t written any reviews yet.';

  @override
  String get likeTooltip => 'Like';

  @override
  String get commentsTooltip => 'Comments';

  @override
  String get commentHint => 'Write a comment...';

  @override
  String get noCommentsYet => 'No comments yet.';

  @override
  String get privacySectionTitle => 'Privacy';

  @override
  String get listSharingOff => 'Off';

  @override
  String get listSharingPublic => 'Public';

  @override
  String get listSharingFollowers => 'Followers Only';

  @override
  String get theirWatchlistTitle => 'Watchlist';

  @override
  String get theirFavoritesTitle => 'Favorites';

  @override
  String get emptySharedListMessage => 'Nothing added yet.';
}
