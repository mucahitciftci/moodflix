import 'l10n/generated/app_localizations.dart';

/// Resolves a [MoodModel.titleKey] (defined once in `MoodConfig`) to its
/// localized string. Kept in one place so mood titles live in the ARB files
/// instead of being hardcoded in the widgets that render them.
extension MoodLocalizer on AppLocalizations {
  String moodTitle(String titleKey) {
    switch (titleKey) {
      case 'mood_mind_bender_title':
        return moodMindBenderTitle;
      case 'mood_nostalgia_title':
        return moodNostalgiaTitle;
      case 'mood_thriller_title':
        return moodThrillerTitle;
      case 'mood_netflix_title':
        return moodNetflixTitle;
      default:
        return titleKey;
    }
  }
}
