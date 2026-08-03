import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../core/localization/locale_provider.dart';

/// Thin wrapper around TMDB's REST API. Returns raw decoded JSON — parsing
/// into domain models (`MovieModel.fromJson`) happens one layer up, in
/// [MovieRepository]. [language] controls the TMDB `language` query param
/// (titles/overviews come back in this language); [tmdbApiServiceProvider]
/// rebuilds this with a fresh [language] whenever `localeProvider` changes,
/// so switching the app's language also switches TMDB's content language.
class TmdbApiService {
  TmdbApiService({required String language, Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              queryParameters: {'language': language},
            ));

  final Dio _dio;

  Map<String, String> get _authParams => {'api_key': ApiConstants.apiKey};

  /// `GET /discover/movie` — [queryParams] carries the mood-specific filters
  /// defined in `MoodConfig` (genres, sort order, vote thresholds, ...).
  Future<Map<String, dynamic>> discoverMovies({
    required Map<String, String> queryParams,
    required int page,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.discoverMovies,
      queryParameters: {
        ..._authParams,
        ...queryParams,
        'page': '$page',
      },
    );
    return response.data!;
  }

  /// `GET /trending/movie/week` — TMDB's own trending ranking, unlike
  /// [discoverMovies] which just sorts a filtered query; used for the
  /// "Popüler" browse entry, which has no mood/genre filter to apply.
  Future<Map<String, dynamic>> trendingMovies({required int page}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.trendingMoviesWeekly,
      queryParameters: {..._authParams, 'page': '$page'},
    );
    return response.data!;
  }

  /// `GET /search/movie` — free-text title search, used by the search
  /// screen. Unlike `discoverMovies`, TMDB's own relevance ranking is kept
  /// as-is (not shuffled) since it's meaningful here.
  Future<Map<String, dynamic>> searchMovies(String query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.searchMovies,
      queryParameters: {..._authParams, 'query': query},
    );
    return response.data!;
  }

  /// `GET /movie/{id}` with videos appended, so the detail screen and the
  /// trailer's YouTube key are fetched in a single round trip.
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.movieDetails}/$movieId',
      queryParameters: {
        ..._authParams,
        'append_to_response': 'videos',
        'include_video_language': ApiConstants.videoLanguagesFallback,
      },
    );
    return response.data!;
  }
}

final tmdbApiServiceProvider = Provider<TmdbApiService>((ref) {
  final locale = ref.watch(localeProvider);
  return TmdbApiService(language: ApiConstants.tmdbLanguageFor(locale.languageCode));
});
