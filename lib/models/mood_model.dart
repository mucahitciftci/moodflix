import 'package:flutter/material.dart';

/// A selectable "mood" (e.g. "Beynimi Yaksın", "Nostalji") that maps to a
/// concrete set of TMDB `/discover/movie` query parameters.
@immutable
class MoodModel {
  final String id;
  final String titleKey;
  final IconData icon;
  final Color color;
  final Map<String, String> discoverQueryParams;

  const MoodModel({
    required this.id,
    required this.titleKey,
    required this.icon,
    required this.color,
    required this.discoverQueryParams,
  });
}
