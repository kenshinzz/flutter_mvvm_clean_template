@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_clean_template/core/di/providers.dart';
import 'package:mvvm_clean_template/l10n/app_localizations.dart';
import 'package:mvvm_clean_template/presentation/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  goldenTest(
    'SettingsPage renders correctly',
    fileName: 'settings_page',
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'light theme',
          child: _buildSettingsPage(ThemeMode.light),
        ),
        GoldenTestScenario(
          name: 'dark theme',
          child: _buildSettingsPage(ThemeMode.dark),
        ),
      ],
    ),
  );
}

Widget _buildSettingsPage(ThemeMode themeMode) {
  SharedPreferences.setMockInitialValues({
    'theme_mode': themeMode.toString(),
    'locale': 'en',
  });

  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        width: 400,
        height: 800,
        child: ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(snapshot.data!),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('th', '')],
            themeMode: themeMode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: const SettingsPage(),
          ),
        ),
      );
    },
  );
}
