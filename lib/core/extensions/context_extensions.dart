import 'package:flutter/material.dart';
import 'package:speckit_flutter_template/l10n/app_localizations.dart';

/// BuildContext extension methods for common operations
extension ContextExtensions on BuildContext {
  // === Theme ===

  /// Get current theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Check if dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // === Media Query ===

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get safe area padding
  EdgeInsets get safePadding => mediaQuery.padding;

  /// Get view insets (keyboard height, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Check if screen is small (phone)
  bool get isSmallScreen => screenWidth < 600;

  /// Check if screen is medium (tablet)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  /// Check if screen is large (desktop)
  bool get isLargeScreen => screenWidth >= 1200;

  // === Orientation ===

  /// Get current orientation
  Orientation get orientation => mediaQuery.orientation;

  /// Check if portrait
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if landscape
  bool get isLandscape => orientation == Orientation.landscape;

  // === Localization ===

  /// Get localizations
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Get current locale
  Locale get locale => Localizations.localeOf(this);

  // === Navigation ===

  /// Pop current route
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// Pop until predicate is true
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      Navigator.of(this).popUntil(predicate);

  /// Pop to first route
  void popToFirst() => Navigator.of(this).popUntil((route) => route.isFirst);

  // === Focus ===

  /// Unfocus current focus (dismiss keyboard)
  void unfocus() => FocusScope.of(this).unfocus();

  /// Request focus on a node
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);

  // === Snackbar ===

  /// Show snackbar with message
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) => ScaffoldMessenger.of(this).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      action: action,
      backgroundColor: backgroundColor,
    ),
  );

  /// Show success snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar(
    String message,
  ) => showSnackBar(message, backgroundColor: Colors.green);

  /// Show error snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
    String message,
  ) => showSnackBar(message, backgroundColor: colorScheme.error);

  /// Hide current snackbar
  void hideSnackBar() => ScaffoldMessenger.of(this).hideCurrentSnackBar();

  // === Dialog ===

  /// Show confirm dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    bool isDangerous = false,
  }) => showDialog<bool>(
    context: this,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText ?? 'Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isDangerous
              ? TextButton.styleFrom(foregroundColor: colorScheme.error)
              : null,
          child: Text(confirmText ?? 'Confirm'),
        ),
      ],
    ),
  );

  /// Show loading dialog
  void showLoadingDialog({String? message}) {
    showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    if (canPop) pop();
  }
}
