import 'package:flutter/foundation.dart';

/// A single TMDB genre (e.g. "Aksiyon", "Komedi"), used by the
/// category-based browsing mode as an alternative to mood-based discovery.
@immutable
class GenreModel {
  final int id;
  final String nameKey;

  const GenreModel({required this.id, required this.nameKey});
}
