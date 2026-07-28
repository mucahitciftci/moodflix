import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:moodflix/main.dart';
import 'package:moodflix/services/local_cache_service.dart';
import 'package:moodflix/viewmodels/auth_viewmodel.dart';

void main() {
  // Hive normally opens via path_provider (`LocalCacheService.init`), which
  // needs platform channels unavailable in plain widget tests — point it at
  // a plain temp directory instead.
  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('moodflix_test_hive');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(LocalCacheService.moviePagesBoxName);
    await Hive.openBox<dynamic>(LocalCacheService.watchlistBoxName);
    await Hive.openBox<dynamic>(LocalCacheService.favoritesBoxName);
    await Hive.openBox<dynamic>(LocalCacheService.appPrefsBoxName);
  });

  testWidgets('MoodflixApp builds without throwing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        // The initial route (AuthGateScreen) watches authStateProvider,
        // which normally talks to real Firebase Auth — not initialized in
        // this test, so it's swapped for a fixed "signed out" stream.
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MoodflixApp(),
      ),
    );
    // Not pumpAndSettle: the login screen's chameleon mascot animates in an
    // infinite repeat(reverse: true) loop, so it would never settle.
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(MoodflixApp), findsOneWidget);
  });
}
