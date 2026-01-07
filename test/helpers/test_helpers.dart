import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_clean_template/l10n/app_localizations.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates a test wrapper widget with all necessary providers and localizations
class TestWrapper extends StatelessWidget {

  const TestWrapper({
    required this.child, super.key,
    this.settingsViewModel,
    this.locale,
  });
  final Widget child;
  final SettingsViewModel? settingsViewModel;
  final Locale? locale;

  @override
  Widget build(BuildContext context) => MaterialApp(
      locale: locale ?? const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('th', '')],
      home: settingsViewModel != null
          ? ChangeNotifierProvider<SettingsViewModel>.value(
              value: settingsViewModel!,
              child: child,
            )
          : child,
    );
}

/// Helper to pump widget with all necessary setup
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget widget, {
  SettingsViewModel? settingsViewModel,
  Locale? locale,
}) async {
  await tester.pumpWidget(
    TestWrapper(
      settingsViewModel: settingsViewModel,
      locale: locale,
      child: widget,
    ),
  );
  await tester.pumpAndSettle();
}

/// Creates a mock SharedPreferences with initial values
Future<SharedPreferences> createMockSharedPreferences({
  Map<String, Object>? values,
}) async {
  SharedPreferences.setMockInitialValues(values ?? {});
  return SharedPreferences.getInstance();
}

/// Extension methods for easier testing
extension WidgetTesterExtensions on WidgetTester {
  /// Find widget by text and tap it
  Future<void> tapByText(String text) async {
    await tap(find.text(text));
    await pumpAndSettle();
  }

  /// Find widget by key and tap it
  Future<void> tapByKey(Key key) async {
    await tap(find.byKey(key));
    await pumpAndSettle();
  }

  /// Find widget by icon and tap it
  Future<void> tapByIcon(IconData icon) async {
    await tap(find.byIcon(icon));
    await pumpAndSettle();
  }

  /// Enter text in a text field found by key
  Future<void> enterTextByKey(Key key, String text) async {
    await enterText(find.byKey(key), text);
    await pumpAndSettle();
  }
}
