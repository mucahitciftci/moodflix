import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moodflix/main.dart';

void main() {
  testWidgets('MoodflixApp builds without throwing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MoodflixApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MoodflixApp), findsOneWidget);
  });
}
