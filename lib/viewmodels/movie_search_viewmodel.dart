import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../repositories/movie_repository.dart';

/// Debounced free-text movie search, backing `SearchScreen`. [search] is
/// safe to call on every keystroke — it waits 400ms of silence before
/// hitting the network, so a fast typist doesn't fire a request per letter.
class MovieSearchViewModel extends AsyncNotifier<List<MovieModel>> {
  Timer? _debounce;

  @override
  Future<List<MovieModel>> build() async {
    ref.onDispose(() => _debounce?.cancel());
    return const [];
  }

  MovieRepository get _repository => ref.read(movieRepositoryProvider);

  void search(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      state = const AsyncLoading();
      try {
        final results = await _repository.searchMovies(query);
        state = AsyncData(results);
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      }
    });
  }
}

final movieSearchViewModelProvider =
    AsyncNotifierProvider<MovieSearchViewModel, List<MovieModel>>(
  MovieSearchViewModel.new,
);
