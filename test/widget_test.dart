import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:offline_resume_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: OfflineResumeApp()));

    // Verify that the app builds.
    expect(find.byType(OfflineResumeApp), findsOneWidget);
  });
}
