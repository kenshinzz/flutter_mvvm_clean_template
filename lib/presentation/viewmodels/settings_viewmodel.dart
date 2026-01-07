import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ViewModel for managing app settings (theme mode and locale)
class SettingsViewModel extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  // Keys for SharedPreferences
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  // Private state
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  // Loading state
  bool _isLoading = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  SettingsViewModel({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences {
    _loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load theme mode
      final themeModeString = _sharedPreferences.getString(_themeModeKey);
      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => ThemeMode.system,
        );
      }

      // Load locale
      final localeString = _sharedPreferences.getString(_localeKey);
      if (localeString != null) {
        _locale = Locale(localeString);
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      await _sharedPreferences.setString(_themeModeKey, mode.toString());
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Set locale (language)
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    try {
      await _sharedPreferences.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  /// Toggle between English and Thai
  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'en') {
      await setLocale(const Locale('th'));
    } else {
      await setLocale(const Locale('en'));
    }
  }

  /// Set English locale
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }

  /// Set Thai locale
  Future<void> setThai() async {
    await setLocale(const Locale('th'));
  }

  /// Reset settings to default
  Future<void> resetSettings() async {
    _themeMode = ThemeMode.system;
    _locale = const Locale('en');
    notifyListeners();

    try {
      await _sharedPreferences.remove(_themeModeKey);
      await _sharedPreferences.remove(_localeKey);
    } catch (e) {
      debugPrint('Error resetting settings: $e');
    }
  }
}
