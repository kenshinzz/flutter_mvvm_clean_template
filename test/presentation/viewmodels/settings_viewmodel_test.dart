import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_clean_template/core/di/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_viewmodel_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ProviderContainer container;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    // Default stubs for SharedPreferences
    when(mockSharedPreferences.getString(any)).thenReturn(null);
    when(
      mockSharedPreferences.setString(any, any),
    ).thenAnswer((_) async => true);
    when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

    // Create a new container with overridden SharedPreferences
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SettingsNotifier', () {
    group('Initial State', () {
      test('should have default theme mode as system', () {
        final state = container.read(settingsProvider);
        expect(state.themeMode, ThemeMode.system);
      });

      test('should have default locale as English', () {
        final state = container.read(settingsProvider);
        expect(state.locale, const Locale('en'));
      });

      test('should not be loading initially', () {
        final state = container.read(settingsProvider);
        expect(state.isLoading, false);
      });
    });

    group('Theme Mode', () {
      test('should change theme mode to dark', () async {
        // Act
        await container
            .read(settingsProvider.notifier)
            .setThemeMode(ThemeMode.dark);

        // Assert
        final state = container.read(settingsProvider);
        expect(state.themeMode, ThemeMode.dark);
        expect(state.isDarkMode, true);
        expect(state.isLightMode, false);
      });

      test('should change theme mode to light', () async {
        // Act
        await container
            .read(settingsProvider.notifier)
            .setThemeMode(ThemeMode.light);

        // Assert
        final state = container.read(settingsProvider);
        expect(state.themeMode, ThemeMode.light);
        expect(state.isLightMode, true);
        expect(state.isDarkMode, false);
      });

      test('should toggle between light and dark themes', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Start with light
        await notifier.setThemeMode(ThemeMode.light);
        expect(container.read(settingsProvider).isLightMode, true);

        // Toggle to dark
        await notifier.toggleTheme();
        expect(container.read(settingsProvider).isDarkMode, true);

        // Toggle back to light
        await notifier.toggleTheme();
        expect(container.read(settingsProvider).isLightMode, true);
      });

      test('should persist theme mode to SharedPreferences', () async {
        // Act
        await container
            .read(settingsProvider.notifier)
            .setThemeMode(ThemeMode.dark);

        // Assert
        verify(
          mockSharedPreferences.setString(
            'theme_mode',
            ThemeMode.dark.toString(),
          ),
        ).called(1);
      });

      test('should not update if same theme mode', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Arrange
        await notifier.setThemeMode(ThemeMode.light);
        clearInteractions(mockSharedPreferences);

        // Act
        await notifier.setThemeMode(ThemeMode.light);

        // Assert - should not call setString again
        verifyNever(mockSharedPreferences.setString(any, any));
      });
    });

    group('Locale', () {
      test('should change locale to Thai', () async {
        // Act
        await container
            .read(settingsProvider.notifier)
            .setLocale(const Locale('th'));

        // Assert
        final state = container.read(settingsProvider);
        expect(state.locale, const Locale('th'));
      });

      test('should toggle between English and Thai', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Start with English (default)
        expect(container.read(settingsProvider).locale.languageCode, 'en');

        // Toggle to Thai
        await notifier.toggleLanguage();
        expect(container.read(settingsProvider).locale.languageCode, 'th');

        // Toggle back to English
        await notifier.toggleLanguage();
        expect(container.read(settingsProvider).locale.languageCode, 'en');
      });

      test('should persist locale to SharedPreferences', () async {
        // Act
        await container
            .read(settingsProvider.notifier)
            .setLocale(const Locale('th'));

        // Assert
        verify(mockSharedPreferences.setString('locale', 'th')).called(1);
      });

      test('should set English locale using helper method', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Arrange
        await notifier.setThai();

        // Act
        await notifier.setEnglish();

        // Assert
        expect(container.read(settingsProvider).locale.languageCode, 'en');
      });

      test('should set Thai locale using helper method', () async {
        // Act
        await container.read(settingsProvider.notifier).setThai();

        // Assert
        expect(container.read(settingsProvider).locale.languageCode, 'th');
      });
    });

    group('Reset Settings', () {
      test('should reset to default values', () async {
        final notifier = container.read(settingsProvider.notifier);

        // Arrange - change values first
        await notifier.setThemeMode(ThemeMode.dark);
        await notifier.setLocale(const Locale('th'));

        // Act
        await notifier.resetSettings();

        // Assert
        final state = container.read(settingsProvider);
        expect(state.themeMode, ThemeMode.system);
        expect(state.locale, const Locale('en'));
      });

      test('should remove settings from SharedPreferences', () async {
        // Act
        await container.read(settingsProvider.notifier).resetSettings();

        // Assert
        verify(mockSharedPreferences.remove('theme_mode')).called(1);
        verify(mockSharedPreferences.remove('locale')).called(1);
      });
    });

    group('Load Settings', () {
      test('should load saved theme mode from SharedPreferences', () {
        // Arrange - set up mock before creating container
        when(
          mockSharedPreferences.getString('theme_mode'),
        ).thenReturn(ThemeMode.dark.toString());

        // Create a new container to trigger fresh build
        final newContainer = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          ],
        );
        addTearDown(newContainer.dispose);

        // Assert
        expect(newContainer.read(settingsProvider).themeMode, ThemeMode.dark);
      });

      test('should load saved locale from SharedPreferences', () {
        // Arrange
        when(mockSharedPreferences.getString('locale')).thenReturn('th');

        // Create a new container to trigger fresh build
        final newContainer = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          ],
        );
        addTearDown(newContainer.dispose);

        // Assert
        expect(newContainer.read(settingsProvider).locale, const Locale('th'));
      });
    });

    group('State Changes', () {
      test('should update state when theme changes', () async {
        var updateCount = 0;
        container.listen(settingsProvider, (previous, next) {
          updateCount++;
        });

        // Act
        await container
            .read(settingsProvider.notifier)
            .setThemeMode(ThemeMode.dark);

        // Assert - state should have been updated
        expect(updateCount, greaterThan(0));
      });

      test('should update state when locale changes', () async {
        var updateCount = 0;
        container.listen(settingsProvider, (previous, next) {
          updateCount++;
        });

        // Act
        await container
            .read(settingsProvider.notifier)
            .setLocale(const Locale('th'));

        // Assert - state should have been updated
        expect(updateCount, greaterThan(0));
      });
    });
  });
}
