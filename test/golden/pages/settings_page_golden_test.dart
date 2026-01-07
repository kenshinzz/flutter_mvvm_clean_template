@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_clean_template/presentation/pages/settings_page.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_helpers.dart';

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

      final viewModel = SettingsViewModel(sharedPreferences: snapshot.data!);

      return SizedBox(
        width: 400,
        height: 800,
        child: TestWrapper(
          settingsViewModel: viewModel,
          child: const SettingsPage(),
        ),
      );
    },
  );
}
