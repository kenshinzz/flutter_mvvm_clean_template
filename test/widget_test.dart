// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speckit_flutter_template/core/di/providers.dart';
import 'package:speckit_flutter_template/l10n/app_localizations.dart';
import 'package:speckit_flutter_template/presentation/pages/home_page.dart';

void main() {
  late Override sharedPrefsOverride;

  setUp(() async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    sharedPrefsOverride = sharedPreferencesProvider.overrideWithValue(prefs);
  });

  Widget buildTestApp({required Widget child}) => ProviderScope(
    overrides: [sharedPrefsOverride],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('th', '')],
      home: child,
    ),
  );

  testWidgets('Counter increments smoke test', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(buildTestApp(child: const HomePage()));
    await tester.pumpAndSettle();

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter decrements when decrease button is pressed', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(child: const HomePage()));
    await tester.pumpAndSettle();

    // Increment first
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    // Tap decrease button
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Verify counter decremented
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Counter resets when reset button is pressed', (tester) async {
    await tester.pumpWidget(buildTestApp(child: const HomePage()));
    await tester.pumpAndSettle();

    // Increment a few times
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    // Tap reset button
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Verify counter reset
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Home page shows welcome message', (tester) async {
    await tester.pumpWidget(buildTestApp(child: const HomePage()));
    await tester.pumpAndSettle();

    // Verify welcome message is displayed
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('Settings button navigates correctly', (tester) async {
    await tester.pumpWidget(buildTestApp(child: const HomePage()));
    await tester.pumpAndSettle();

    // Verify settings icon exists (in app bar)
    expect(find.byIcon(Icons.settings), findsWidgets);
  });
}
