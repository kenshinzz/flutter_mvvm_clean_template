import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_clean_template/core/di/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State class for settings
@immutable
class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.isLoading = false,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final bool isLoading;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;
  bool get isSystemMode => themeMode == ThemeMode.system;

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isLoading,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
        isLoading: isLoading ?? this.isLoading,
      );
}

/// Notifier for managing app settings (theme mode and locale)
class SettingsNotifier extends Notifier<SettingsState> {
  // Keys for SharedPreferences
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  late final SharedPreferences _sharedPreferences;

  @override
  SettingsState build() {
    // Get SharedPreferences from Riverpod provider
    _sharedPreferences = ref.watch(sharedPreferencesProvider);

    // Load settings synchronously from SharedPreferences
    final themeModeString = _sharedPreferences.getString(_themeModeKey);
    var themeMode = ThemeMode.system;
    if (themeModeString != null) {
      themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }

    final localeString = _sharedPreferences.getString(_localeKey);
    var locale = const Locale('en');
    if (localeString != null) {
      locale = Locale(localeString);
    }

    return SettingsState(
      themeMode: themeMode,
      locale: locale,
    );
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;

    state = state.copyWith(themeMode: mode);

    try {
      await _sharedPreferences.setString(_themeModeKey, mode.toString());
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (state.themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  Future<void> setLightTheme() => setThemeMode(ThemeMode.light);

  /// Set dark theme
  Future<void> setDarkTheme() => setThemeMode(ThemeMode.dark);

  /// Set system theme
  Future<void> setSystemTheme() => setThemeMode(ThemeMode.system);

  /// Set locale (language)
  Future<void> setLocale(Locale locale) async {
    if (state.locale == locale) return;

    state = state.copyWith(locale: locale);

    try {
      await _sharedPreferences.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  /// Toggle between English and Thai
  Future<void> toggleLanguage() async {
    if (state.locale.languageCode == 'en') {
      await setLocale(const Locale('th'));
    } else {
      await setLocale(const Locale('en'));
    }
  }

  /// Set English locale
  Future<void> setEnglish() => setLocale(const Locale('en'));

  /// Set Thai locale
  Future<void> setThai() => setLocale(const Locale('th'));

  /// Reset settings to default
  Future<void> resetSettings() async {
    state = const SettingsState();

    try {
      await _sharedPreferences.remove(_themeModeKey);
      await _sharedPreferences.remove(_localeKey);
    } catch (e) {
      debugPrint('Error resetting settings: $e');
    }
  }
}

/// Provider for SettingsNotifier
final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
