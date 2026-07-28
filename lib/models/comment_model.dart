import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// A comment on a [ReviewModel], stored in Firestore's
/// `reviews/{reviewId}/comments` subcollection.
@immutable
class CommentModel {
  final String id;
  final String userId;
  final String authorDisplayName;
  final String text;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.userId,
    required this.authorDisplayName,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromFirestore(String id, Map<String, dynamic> data) {
    final timestamp = data['createdAt'];
    return CommentModel(
      id: id,
      userId: data['userId'] as String,
      authorDisplayName: data['authorDisplayName'] as String? ?? '',
      text: data['text'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'authorDisplayName': authorDisplayName,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
