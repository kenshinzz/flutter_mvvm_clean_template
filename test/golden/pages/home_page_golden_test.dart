@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_clean_template/presentation/pages/home_page.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_helpers.dart';

void main() {
  goldenTest(
    'HomePage renders correctly',
    fileName: 'home_page',
    pumpBeforeTest: (tester) async {
      // Wait for all animations to complete
      await tester.pumpAndSettle();
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'light theme - english',
          child: _buildHomePage(ThemeMode.light, const Locale('en')),
        ),
        GoldenTestScenario(
          name: 'dark theme - english',
          child: _buildHomePage(ThemeMode.dark, const Locale('en')),
        ),
        GoldenTestScenario(
          name: 'light theme - thai',
          child: _buildHomePage(ThemeMode.light, const Locale('th')),
        ),
        GoldenTestScenario(
          name: 'dark theme - thai',
          child: _buildHomePage(ThemeMode.dark, const Locale('th')),
        ),
      ],
    ),
  );
}

Widget _buildHomePage(ThemeMode themeMode, Locale locale) {
  // Create a mock SharedPreferences synchronously for golden tests
  SharedPreferences.setMockInitialValues({
    'theme_mode': themeMode.toString(),
    'locale': locale.languageCode,
  });

  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const SizedBox.shrink();
      }

      final viewModel = SettingsViewModel(sharedPreferences: snapshot.data!);

      return SizedBox(
        width: 400,
        height: 800,
        child: TestWrapper(
          settingsViewModel: viewModel,
          locale: locale,
          child: const HomePage(),
        ),
      );
    },
  );
}
