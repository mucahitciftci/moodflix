import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the device currently has any network connectivity. Used to gate
/// trailer playback — TMDB only gives us a YouTube video ID, never a
/// downloadable file, so trailer playback always needs a live connection
/// while everything else (posters, summaries, watch lists) works from Hive
/// cache regardless.
final connectivityStatusProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  final initial = await connectivity.checkConnectivity();
  yield !initial.contains(ConnectivityResult.none);

  yield* connectivity.onConnectivityChanged.map(
    (results) => !results.contains(ConnectivityResult.none),
  );
});
