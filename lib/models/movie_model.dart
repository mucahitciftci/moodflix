import 'package:flutter/foundation.dart';

/// A single movie/TV result, as returned by TMDB's `/discover/movie`,
/// `/search/movie`, `/movie/{id}` and `/movie/{id}/videos` endpoints.
@immutable
class MovieModel {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<int> genreIds;
  final String? trailerYoutubeKey;

  const MovieModel({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.releaseDate,
    this.genreIds = const [],
    this.trailerYoutubeKey,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      // TMDB uses `title` for movies and `name` for TV shows.
      title: (json['title'] ?? json['name'] ?? '') as String,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      genreIds: _extractGenreIds(json),
      trailerYoutubeKey: _extractTrailerKey(json['videos']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'release_date': releaseDate,
        'genre_ids': genreIds,
        'trailer_youtube_key': trailerYoutubeKey,
      };

  MovieModel copyWith({String? trailerYoutubeKey}) => MovieModel(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
        releaseDate: releaseDate,
        genreIds: genreIds,
        trailerYoutubeKey: trailerYoutubeKey ?? this.trailerYoutubeKey,
      );

  /// List endpoints (`/discover/movie`, `/search/movie`) return a flat
  /// `genre_ids: [int]`; the single-movie endpoint (`/movie/{id}`) instead
  /// returns `genres: [{id, name}]`. Both are handled so genre/mood badges
  /// work the same whether a movie came from a list or a detail fetch.
  static List<int> _extractGenreIds(Map<String, dynamic> json) {
    final genreIds = json['genre_ids'];
    if (genreIds is List) {
      return genreIds.map((e) => e as int).toList();
    }
    final genres = json['genres'];
    if (genres is List) {
      return genres
          .whereType<Map<String, dynamic>>()
          .map((g) => g['id'] as int)
          .toList();
    }
    return const [];
  }

  /// Picks the best trailer key out of an embedded `videos` response
  /// (`{"videos": {"results": [...]}}`, as returned when `append_to_response
  /// =videos` is used on `/movie/{id}`). Prefers an official YouTube
  /// "Trailer", falling back to the first available YouTube video.
  static String? _extractTrailerKey(dynamic videos) {
    if (videos is! Map<String, dynamic>) return null;
    final results = videos['results'];
    if (results is! List) return null;

    final youtubeVideos = results
        .whereType<Map<String, dynamic>>()
        .where((v) => v['site'] == 'YouTube')
        .toList();
    if (youtubeVideos.isEmpty) return null;

    final trailer = youtubeVideos.firstWhere(
      (v) => v['type'] == 'Trailer',
      orElse: () => youtubeVideos.first,
    );
    return trailer['key'] as String?;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MovieModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
