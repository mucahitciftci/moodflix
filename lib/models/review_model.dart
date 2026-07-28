import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// A user-written review for a movie, stored in Firestore's `reviews`
/// collection. Distinct from [MovieModel] — this is our own social-feature
/// data, not anything TMDB provides.
@immutable
class ReviewModel {
  final String id;
  final int movieId;
  final String movieTitle;
  final String? moviePosterPath;
  final String userId;
  final String authorDisplayName;
  final double rating;
  final String text;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    this.moviePosterPath,
    required this.userId,
    required this.authorDisplayName,
    required this.rating,
    required this.text,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(String id, Map<String, dynamic> data) {
    final timestamp = data['createdAt'];
    return ReviewModel(
      id: id,
      // `as num` rather than `as int` — on Flutter Web, cloud_firestore's
      // JS interop can hand back a whole-number Firestore integer as a
      // Dart `double` (JS has no distinct int type), so a direct `as int`
      // cast throws there even though it works fine on native platforms.
      movieId: (data['movieId'] as num).toInt(),
      // Reviews written before this field existed just show no title —
      // graceful, not a crash (see `ReviewTile`'s `movieTitle.isNotEmpty`).
      movieTitle: data['movieTitle'] as String? ?? '',
      moviePosterPath: data['moviePosterPath'] as String?,
      userId: data['userId'] as String,
      authorDisplayName: data['authorDisplayName'] as String? ?? '',
      rating: (data['rating'] as num).toDouble(),
      text: data['text'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }

  /// `createdAt` is written as a server timestamp so review ordering isn't
  /// affected by the poster's device clock being wrong. `movieTitle`/
  /// `moviePosterPath` are denormalized from the movie at write time (same
  /// pattern as `authorDisplayName`) so showing a review on a user's
  /// profile — where the movie isn't otherwise on screen — needs no extra
  /// TMDB fetch.
  Map<String, dynamic> toFirestore() => {
        'movieId': movieId,
        'movieTitle': movieTitle,
        'moviePosterPath': moviePosterPath,
        'userId': userId,
        'authorDisplayName': authorDisplayName,
        'rating': rating,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
