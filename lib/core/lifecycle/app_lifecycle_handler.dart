import 'package:flutter/material.dart';

/// Callback types for lifecycle events
typedef LifecycleCallback = void Function();

/// Handler for app lifecycle events
/// Wrap your app with this to respond to lifecycle changes
class AppLifecycleHandler extends StatefulWidget {
  const AppLifecycleHandler({
    required this.child,
    super.key,
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
    this.onHidden,
  });

  final Widget child;

  /// Called when the app is visible and responding to user input
  final LifecycleCallback? onResumed;

  /// Called when the app is not visible and not responding to user input
  final LifecycleCallback? onPaused;

  /// Called when the app is inactive (e.g., phone call, system dialog)
  final LifecycleCallback? onInactive;

  /// Called when the app is detached
  final LifecycleCallback? onDetached;

  /// Called when the app is hidden
  final LifecycleCallback? onHidden;

  @override
  State<AppLifecycleHandler> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends State<AppLifecycleHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResumed?.call();
      case AppLifecycleState.paused:
        widget.onPaused?.call();
      case AppLifecycleState.inactive:
        widget.onInactive?.call();
      case AppLifecycleState.detached:
        widget.onDetached?.call();
      case AppLifecycleState.hidden:
        widget.onHidden?.call();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Mixin to add lifecycle handling to a StatefulWidget
/// Use this when you need lifecycle handling in a specific page/widget
///
/// Example:
/// ```dart
/// class MyPageState extends State<MyPage> with AppLifecycleMixin {
///   @override
///   void onResumed() {
///     // Refresh data when app comes to foreground
///     _loadData();
///   }
///
///   @override
///   void onPaused() {
///     // Save state when app goes to background
///     _saveState();
///   }
/// }
/// ```
mixin AppLifecycleMixin<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
      case AppLifecycleState.paused:
        onPaused();
      case AppLifecycleState.inactive:
        onInactive();
      case AppLifecycleState.detached:
        onDetached();
      case AppLifecycleState.hidden:
        onHidden();
    }
  }

  /// Override to handle when app is resumed
  void onResumed() {}

  /// Override to handle when app is paused
  void onPaused() {}

  /// Override to handle when app is inactive
  void onInactive() {}

  /// Override to handle when app is detached
  void onDetached() {}

  /// Override to handle when app is hidden
  void onHidden() {}

  // Required WidgetsBindingObserver methods with default implementations
  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() => Future<bool>.value(false);

  @override
  Future<bool> didPushRoute(String route) => Future<bool>.value(false);

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      Future<bool>.value(false);
}
