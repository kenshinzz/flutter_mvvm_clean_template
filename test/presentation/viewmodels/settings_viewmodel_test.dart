import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart';

import 'settings_viewmodel_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late SettingsViewModel viewModel;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    // Default stubs for SharedPreferences
    when(mockSharedPreferences.getString(any)).thenReturn(null);
    when(
      mockSharedPreferences.setString(any, any),
    ).thenAnswer((_) async => true);
    when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

    viewModel = SettingsViewModel(sharedPreferences: mockSharedPreferences);
  });

  group('SettingsViewModel', () {
    group('Initial State', () {
      test('should have default theme mode as system', () {
        expect(viewModel.themeMode, ThemeMode.system);
      });

      test('should have default locale as English', () {
        expect(viewModel.locale, const Locale('en'));
      });

      test('should not be loading initially after construction', () async {
        // Wait for async initialization to complete
        await Future.delayed(Duration.zero);
        expect(viewModel.isLoading, false);
      });
    });

    group('Theme Mode', () {
      test('should change theme mode to dark', () async {
        // Act
        await viewModel.setThemeMode(ThemeMode.dark);

        // Assert
        expect(viewModel.themeMode, ThemeMode.dark);
        expect(viewModel.isDarkMode, true);
        expect(viewModel.isLightMode, false);
      });

      test('should change theme mode to light', () async {
        // Act
        await viewModel.setThemeMode(ThemeMode.light);

        // Assert
        expect(viewModel.themeMode, ThemeMode.light);
        expect(viewModel.isLightMode, true);
        expect(viewModel.isDarkMode, false);
      });

      test('should toggle between light and dark themes', () async {
        // Start with light
        await viewModel.setThemeMode(ThemeMode.light);
        expect(viewModel.isLightMode, true);

        // Toggle to dark
        await viewModel.toggleTheme();
        expect(viewModel.isDarkMode, true);

        // Toggle back to light
        await viewModel.toggleTheme();
        expect(viewModel.isLightMode, true);
      });

      test('should persist theme mode to SharedPreferences', () async {
        // Act
        await viewModel.setThemeMode(ThemeMode.dark);

        // Assert
        verify(
          mockSharedPreferences.setString(
            'theme_mode',
            ThemeMode.dark.toString(),
          ),
        ).called(1);
      });

      test('should not update if same theme mode', () async {
        // Arrange
        await viewModel.setThemeMode(ThemeMode.light);
        clearInteractions(mockSharedPreferences);

        // Act
        await viewModel.setThemeMode(ThemeMode.light);

        // Assert - should not call setString again
        verifyNever(mockSharedPreferences.setString(any, any));
      });
    });

    group('Locale', () {
      test('should change locale to Thai', () async {
        // Act
        await viewModel.setLocale(const Locale('th'));

        // Assert
        expect(viewModel.locale, const Locale('th'));
      });

      test('should toggle between English and Thai', () async {
        // Start with English (default)
        expect(viewModel.locale.languageCode, 'en');

        // Toggle to Thai
        await viewModel.toggleLanguage();
        expect(viewModel.locale.languageCode, 'th');

        // Toggle back to English
        await viewModel.toggleLanguage();
        expect(viewModel.locale.languageCode, 'en');
      });

      test('should persist locale to SharedPreferences', () async {
        // Act
        await viewModel.setLocale(const Locale('th'));

        // Assert
        verify(mockSharedPreferences.setString('locale', 'th')).called(1);
      });

      test('should set English locale using helper method', () async {
        // Arrange
        await viewModel.setThai();

        // Act
        await viewModel.setEnglish();

        // Assert
        expect(viewModel.locale.languageCode, 'en');
      });

      test('should set Thai locale using helper method', () async {
        // Act
        await viewModel.setThai();

        // Assert
        expect(viewModel.locale.languageCode, 'th');
      });
    });

    group('Reset Settings', () {
      test('should reset to default values', () async {
        // Arrange - change values first
        await viewModel.setThemeMode(ThemeMode.dark);
        await viewModel.setLocale(const Locale('th'));

        // Act
        await viewModel.resetSettings();

        // Assert
        expect(viewModel.themeMode, ThemeMode.system);
        expect(viewModel.locale, const Locale('en'));
      });

      test('should remove settings from SharedPreferences', () async {
        // Act
        await viewModel.resetSettings();

        // Assert
        verify(mockSharedPreferences.remove('theme_mode')).called(1);
        verify(mockSharedPreferences.remove('locale')).called(1);
      });
    });

    group('Load Settings', () {
      test('should load saved theme mode from SharedPreferences', () {
        // Arrange
        when(
          mockSharedPreferences.getString('theme_mode'),
        ).thenReturn(ThemeMode.dark.toString());

        // Act - create new instance to trigger load
        final newViewModel = SettingsViewModel(
          sharedPreferences: mockSharedPreferences,
        );

        // Assert (after async load completes)
        expect(newViewModel.themeMode, ThemeMode.dark);
      });

      test('should load saved locale from SharedPreferences', () {
        // Arrange
        when(mockSharedPreferences.getString('locale')).thenReturn('th');

        // Act - create new instance to trigger load
        final newViewModel = SettingsViewModel(
          sharedPreferences: mockSharedPreferences,
        );

        // Assert (after async load completes)
        expect(newViewModel.locale, const Locale('th'));
      });
    });

    group('Notifier', () {
      test('should notify listeners when theme changes', () async {
        // Arrange
        var notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        await viewModel.setThemeMode(ThemeMode.dark);

        // Assert
        expect(notified, true);
      });

      test('should notify listeners when locale changes', () async {
        // Arrange
        var notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        await viewModel.setLocale(const Locale('th'));

        // Assert
        expect(notified, true);
      });
    });
  });
}
