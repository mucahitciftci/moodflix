import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// The application name, shown as the OS task title.
  ///
  /// In en, this message translates to:
  /// **'Moodflix'**
  String get appTitle;

  /// Short tagline shown under the app name on the login/sign-up screens.
  ///
  /// In en, this message translates to:
  /// **'Movies that match your mood'**
  String get authTagline;

  /// Mood: mind-bending / thought-provoking films (mystery, sci-fi, thriller).
  ///
  /// In en, this message translates to:
  /// **'Mind Bender'**
  String get moodMindBenderTitle;

  /// Mood: older, nostalgic drama/family/adventure titles.
  ///
  /// In en, this message translates to:
  /// **'Nostalgia'**
  String get moodNostalgiaTitle;

  /// Mood: thriller/crime titles.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get moodThrillerTitle;

  /// Mood: popular titles currently on Netflix.
  ///
  /// In en, this message translates to:
  /// **'Netflix Movies'**
  String get moodNetflixTitle;

  /// Shown on the discovery screen when a mood's first page comes back empty.
  ///
  /// In en, this message translates to:
  /// **'No movies found for this mood.'**
  String get emptyMovies;

  /// Generic fallback error message shown when a network call fails.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Title of the screen combining the watchlist and favorites tabs.
  ///
  /// In en, this message translates to:
  /// **'My Lists'**
  String get myListsScreenTitle;

  /// Tab label for the user's watchlist (movies swiped right).
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlistTabLabel;

  /// Tab label for the user's favorites (movies favorited from the detail screen).
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTabLabel;

  /// Shown when the watchlist tab has no movies.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added anything to your watchlist yet.'**
  String get emptyWatchlist;

  /// Shown when the favorites tab has no movies.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any favorites yet.'**
  String get emptyFavorites;

  /// Tooltip/label for the remove button on a saved movie row.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeFromListTooltip;

  /// Tooltip for the favorite button on the detail screen, shown when not yet favorited.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavoritesTooltip;

  /// Tooltip for the favorite button on the detail screen, shown when already favorited.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavoritesTooltip;

  /// Tooltip for the share button on the detail screen.
  ///
  /// In en, this message translates to:
  /// **'Send to a friend'**
  String get shareTooltip;

  /// Text shared via share_plus when the user taps the share button.
  ///
  /// In en, this message translates to:
  /// **'Check out {title}: {url}'**
  String shareMessage(String title, String url);

  /// Heading above the trailer player/placeholder on the detail screen.
  ///
  /// In en, this message translates to:
  /// **'Trailer'**
  String get trailerSectionTitle;

  /// Shown instead of the trailer player when the device is offline.
  ///
  /// In en, this message translates to:
  /// **'You need an internet connection to watch the trailer.'**
  String get trailerRequiresInternet;

  /// Shown when the movie has no YouTube trailer on TMDB.
  ///
  /// In en, this message translates to:
  /// **'No trailer available for this movie.'**
  String get trailerUnavailable;

  /// Heading on the first screen, asking mood-based vs category-based browsing.
  ///
  /// In en, this message translates to:
  /// **'How would you like to find movies?'**
  String get howToBrowseTitle;

  /// Option to browse via the curated mood cards (Mind Bender, Nostalgia, ...).
  ///
  /// In en, this message translates to:
  /// **'By Mood'**
  String get browseByMoodLabel;

  /// Subtitle under the 'By Mood' browse option.
  ///
  /// In en, this message translates to:
  /// **'Get picks that match how you feel'**
  String get browseByMoodSubtitle;

  /// Option to browse via the full TMDB genre list.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get browseByCategoryLabel;

  /// Subtitle under the 'By Category' browse option.
  ///
  /// In en, this message translates to:
  /// **'Pick a genre and browse everything in it'**
  String get browseByCategorySubtitle;

  /// Option to browse TMDB's actual trending ranking, no mood/genre filter.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get browseByTrendingLabel;

  /// Subtitle under the 'Trending' browse option.
  ///
  /// In en, this message translates to:
  /// **'See what everyone\'s watching right now'**
  String get browseByTrendingSubtitle;

  /// App bar title of the discovery screen when browsing trending movies.
  ///
  /// In en, this message translates to:
  /// **'Trending Movies'**
  String get trendingMoviesTitle;

  /// App bar title of the mood selection screen (no longer the app's home screen).
  ///
  /// In en, this message translates to:
  /// **'Choose a Mood'**
  String get moodSelectionTitle;

  /// App bar title of the category (genre) selection screen.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categorySelectionTitle;

  /// No description provided for @genreAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get genreAction;

  /// No description provided for @genreAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get genreAdventure;

  /// No description provided for @genreAnimation.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get genreAnimation;

  /// No description provided for @genreComedy.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get genreComedy;

  /// No description provided for @genreCrime.
  ///
  /// In en, this message translates to:
  /// **'Crime'**
  String get genreCrime;

  /// No description provided for @genreDocumentary.
  ///
  /// In en, this message translates to:
  /// **'Documentary'**
  String get genreDocumentary;

  /// No description provided for @genreDrama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get genreDrama;

  /// No description provided for @genreFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get genreFamily;

  /// No description provided for @genreFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get genreFantasy;

  /// No description provided for @genreHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get genreHistory;

  /// No description provided for @genreHorror.
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get genreHorror;

  /// No description provided for @genreMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get genreMusic;

  /// No description provided for @genreMystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get genreMystery;

  /// No description provided for @genreRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get genreRomance;

  /// No description provided for @genreScienceFiction.
  ///
  /// In en, this message translates to:
  /// **'Science Fiction'**
  String get genreScienceFiction;

  /// No description provided for @genreTvMovie.
  ///
  /// In en, this message translates to:
  /// **'TV Movie'**
  String get genreTvMovie;

  /// No description provided for @genreThriller.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get genreThriller;

  /// No description provided for @genreWar.
  ///
  /// In en, this message translates to:
  /// **'War'**
  String get genreWar;

  /// No description provided for @genreWestern.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get genreWestern;

  /// Placeholder text in the search bar/field.
  ///
  /// In en, this message translates to:
  /// **'Search for a movie...'**
  String get searchHint;

  /// Shown on the search screen before the user has typed anything.
  ///
  /// In en, this message translates to:
  /// **'Start typing a movie name'**
  String get searchPrompt;

  /// Shown on the search screen when the query matches no movies.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// Tooltip for the home-shortcut icon on screens deep in the navigation stack.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get homeTooltip;

  /// Tooltip for the undo-last-swipe button on the discovery card stack.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoSwipeTooltip;

  /// Title of the account/preferences screen, and tooltip for its entry icon.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get settingsScreenTitle;

  /// Section heading above the light/dark/system theme options.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSectionTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Section heading above the TR/EN language options.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageTr.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTr;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @loginScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginScreenTitle;

  /// No description provided for @signUpScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpScreenTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get displayNameLabel;

  /// No description provided for @forgotPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLabel;

  /// No description provided for @sendResetLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendResetLinkLabel;

  /// No description provided for @resetLinkSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email.'**
  String get resetLinkSentMessage;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @goToSignUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get goToSignUpLabel;

  /// No description provided for @goToLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get goToLoginLabel;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Check your details and try again.'**
  String get authErrorGeneric;

  /// Section heading on the settings screen for login/logout.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionTitle;

  /// No description provided for @logoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutLabel;

  /// No description provided for @notLoggedInMessage.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedInMessage;

  /// Heading above the review list on the movie detail screen.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsSectionTitle;

  /// No description provided for @writeReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReviewLabel;

  /// No description provided for @writeReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get writeReviewTitle;

  /// No description provided for @reviewTextHint.
  ///
  /// In en, this message translates to:
  /// **'What did you think of this movie?'**
  String get reviewTextHint;

  /// No description provided for @submitReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitReviewLabel;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first to write one!'**
  String get noReviewsYet;

  /// Button on the startup auth screen to skip login and browse without an account.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuestLabel;

  /// Divider text between the email/password form and social sign-in buttons.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWithLabel;

  /// Button to sign in with a Google account.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogleLabel;

  /// Button to sign in with an Apple ID.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithAppleLabel;

  /// Personalized variant of howToBrowseTitle, shown when signed in.
  ///
  /// In en, this message translates to:
  /// **'How would you like to find movies, {name}?'**
  String howToBrowseTitleWithName(String name);

  /// No description provided for @changePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get changePhotoLabel;

  /// No description provided for @choosePhotoFromGalleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get choosePhotoFromGalleryLabel;

  /// No description provided for @takePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhotoLabel;

  /// No description provided for @removePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhotoLabel;

  /// No description provided for @createPresetAvatarLabel.
  ///
  /// In en, this message translates to:
  /// **'Create a preset avatar'**
  String get createPresetAvatarLabel;

  /// No description provided for @chooseAnimalLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose an animal'**
  String get chooseAnimalLabel;

  /// No description provided for @chooseColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose a color'**
  String get chooseColorLabel;

  /// No description provided for @changeUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Username'**
  String get changeUsernameLabel;

  /// No description provided for @changeEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmailLabel;

  /// No description provided for @changePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordLabel;

  /// No description provided for @newEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get newEmailLabel;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @usernameUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your username was updated.'**
  String get usernameUpdatedMessage;

  /// No description provided for @emailUpdateSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to your new email. It will change once you confirm it.'**
  String get emailUpdateSentMessage;

  /// No description provided for @passwordUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password was updated.'**
  String get passwordUpdatedMessage;

  /// Title of the screen for finding/following other users, and tooltip for its entry icon.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get socialScreenTitle;

  /// No description provided for @searchTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTabLabel;

  /// No description provided for @followingTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingTabLabel;

  /// No description provided for @searchUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsersHint;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @noFollowingYet.
  ///
  /// In en, this message translates to:
  /// **'You\'re not following anyone yet'**
  String get noFollowingYet;

  /// No description provided for @followButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followButtonLabel;

  /// Shown on the follow button when already following someone; tapping it unfollows.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get unfollowButtonLabel;

  /// No description provided for @userHasNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'This user hasn\'t written any reviews yet.'**
  String get userHasNoReviewsYet;

  /// No description provided for @likeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeTooltip;

  /// No description provided for @commentsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTooltip;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get commentHint;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get noCommentsYet;

  /// Section heading on the settings screen for watchlist/favorites sharing visibility.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacySectionTitle;

  /// List-sharing option: watchlist/favorites are not shared with anyone.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get listSharingOff;

  /// List-sharing option: watchlist/favorites are visible to any signed-in user.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get listSharingPublic;

  /// List-sharing option: watchlist/favorites are visible only to people who follow you.
  ///
  /// In en, this message translates to:
  /// **'Followers Only'**
  String get listSharingFollowers;

  /// Heading for another user's shared watchlist section on their profile.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get theirWatchlistTitle;

  /// Heading for another user's shared favorites section on their profile.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get theirFavoritesTitle;

  /// No description provided for @emptySharedListMessage.
  ///
  /// In en, this message translates to:
  /// **'Nothing added yet.'**
  String get emptySharedListMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
