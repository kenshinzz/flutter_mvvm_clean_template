import 'package:flutter/material.dart';

/// A customizable loading widget
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.size = 40.0,
    this.color,
    this.strokeWidth = 3.0,
    this.message,
    this.padding = const EdgeInsets.all(16),
  });

  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;
  final EdgeInsets padding;

  /// Full screen loading overlay
  static Widget fullScreen({String? message, Color? backgroundColor}) =>
      ColoredBox(
        color: backgroundColor ?? Colors.black26,
        child: Center(child: LoadingWidget(message: message)),
      );

  /// Small inline loading indicator
  static Widget inline({double size = 20.0, Color? color}) => LoadingWidget(
    size: size,
    color: color,
    strokeWidth: 2,
    padding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A loading overlay that can be shown over content
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
    this.message,
    this.backgroundColor,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      if (isLoading)
        Positioned.fill(
          child: LoadingWidget.fullScreen(
            message: message,
            backgroundColor: backgroundColor,
          ),
        ),
    ],
  );
}
