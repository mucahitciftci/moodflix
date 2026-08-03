import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized API configuration. Nothing here is hardcoded in services —
/// the API key is read from `.env` (never committed, see `.gitignore`).
abstract final class ApiConstants {
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  static String get baseUrl =>
      dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';

  static String get imageBaseUrl =>
      dotenv.env['TMDB_IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p';

  /// The Firebase-generated **Web** OAuth client ID for Google Sign-In —
  /// used as `clientId` on web and `serverClientId` on Android/iOS (the
  /// latter is what lets those platforms return a Firebase-verifiable ID
  /// token, not just an access token). Get this from Firebase Console →
  /// Authentication → Sign-in method → Google, after enabling it.
  static String get googleWebClientId => dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  // Poster/backdrop image sizes, per https://developer.themoviedb.org/docs/image-basics
  static const String posterSizeSmall = 'w154';
  static const String posterSizeMedium = 'w342';
  static const String posterSizeLarge = 'w780';
  static const String backdropSize = 'w1280';

  static const int defaultPageSize = 20;

  /// Maps our app locale (`LocaleNotifier`'s `tr`/`en`) to TMDB's expected
  /// `language` query param (ISO 639-1 + region) — this is what actually
  /// makes overviews/titles come back in the selected language, separate
  /// from the app's own UI localization (ARB files).
  static String tmdbLanguageFor(String languageCode) =>
      languageCode == 'en' ? 'en-US' : 'tr-TR';

  /// TMDB's `append_to_response=videos` only returns videos matching the
  /// request's `language` by default — since most trailers on TMDB are only
  /// tagged `en` (or untagged), restricting to the request's own language
  /// alone hides almost every trailer. This widens the video language
  /// filter without changing the language used for titles/overviews.
  static const String videoLanguagesFallback = 'en,tr,null';

  // Endpoints (relative to baseUrl)
  static const String discoverMovies = '/discover/movie';
  static const String trendingMoviesWeekly = '/trending/movie/week';
  static const String searchMovies = '/search/movie';
  static const String movieDetails = '/movie'; // + /{id}
  static const String movieVideos = '/videos'; // + appended to /movie/{id}
  static const String movieGenres = '/genre/movie/list';

  // Youtube trailer embed
  static const String youtubeThumbnailUrl = 'https://img.youtube.com/vi';
  static const String youtubeThumbnailQuality = 'hqdefault.jpg';

  static String posterUrl(String? path, {String size = posterSizeMedium}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl/$size$path';
  }

  static String backdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl/$backdropSize$path';
  }

  static String youtubeThumbnailFor(String videoId) =>
      '$youtubeThumbnailUrl/$videoId/$youtubeThumbnailQuality';

  /// TMDB's own web page for a movie — used as the link in "arkadaşa
  /// gönder" shares, since the app itself has no public deep link.
  static String movieWebUrl(int movieId) =>
      'https://www.themoviedb.org/movie/$movieId';
}
