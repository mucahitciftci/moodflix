import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// A user-written review for a movie, stored in Firestore's `reviews`
/// collection. Distinct from [MovieModel] — this is our own social-feature
/// data, not anything TMDB provides.
@immutable
class ReviewModel {
  final String id;
  final int movieId;
  final String userId;
  final String authorDisplayName;
  final double rating;
  final String text;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.movieId,
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
      movieId: data['movieId'] as int,
      userId: data['userId'] as String,
      authorDisplayName: data['authorDisplayName'] as String? ?? '',
      rating: (data['rating'] as num).toDouble(),
      text: data['text'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }

  /// `createdAt` is written as a server timestamp so review ordering isn't
  /// affected by the poster's device clock being wrong.
  Map<String, dynamic> toFirestore() => {
        'movieId': movieId,
        'userId': userId,
        'authorDisplayName': authorDisplayName,
        'rating': rating,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
