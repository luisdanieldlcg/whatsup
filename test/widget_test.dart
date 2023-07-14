// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_firebase_template/main.dart';

void main() {
  testWidgets('Theme notifier toggles theme', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // find switch widget
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    // if the switch value is false, then the theme mode is light
    final themeA = tester.widget<Switch>(switchFinder).value;

    // tap the switch
    await tester.tap(switchFinder);
    await tester.pump();

    final themeB = tester.widget<Switch>(switchFinder).value;

    // expect the theme to be toggled, i.e. themeA != themeB
    expect(themeA != themeB, true);
  });
}
