import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/preset_avatar_config.dart';

/// A comment on a [ReviewModel], stored in Firestore's
/// `reviews/{reviewId}/comments` subcollection.
@immutable
class CommentModel {
  final String id;
  final String userId;
  final String authorDisplayName;
  final String? authorPhotoBase64;
  final PresetAnimal? authorPresetAvatarAnimal;
  final int? authorPresetAvatarColorValue;
  final String text;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.userId,
    required this.authorDisplayName,
    this.authorPhotoBase64,
    this.authorPresetAvatarAnimal,
    this.authorPresetAvatarColorValue,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromFirestore(String id, Map<String, dynamic> data) {
    final timestamp = data['createdAt'];
    return CommentModel(
      id: id,
      userId: data['userId'] as String,
      authorDisplayName: data['authorDisplayName'] as String? ?? '',
      authorPhotoBase64: data['authorPhotoBase64'] as String?,
      authorPresetAvatarAnimal: PresetAnimal.fromKey(data['authorPresetAvatarAnimal'] as String?),
      authorPresetAvatarColorValue: (data['authorPresetAvatarColorValue'] as num?)?.toInt(),
      text: data['text'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'authorDisplayName': authorDisplayName,
        'authorPhotoBase64': authorPhotoBase64,
        'authorPresetAvatarAnimal': authorPresetAvatarAnimal?.name,
        'authorPresetAvatarColorValue': authorPresetAvatarColorValue,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
