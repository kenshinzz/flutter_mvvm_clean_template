import 'package:flutter/material.dart';

/// A customizable empty state widget
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.message,
    super.key,
    this.title,
    this.icon,
    this.iconSize = 80.0,
    this.action,
    this.actionLabel,
  });

  /// Common empty states
  factory EmptyStateWidget.noData({
    String? message,
    VoidCallback? onRefresh,
    String? refreshLabel,
  }) => EmptyStateWidget(
    icon: Icons.inbox_rounded,
    title: 'No Data',
    message: message ?? 'There is no data to display.',
    action: onRefresh,
    actionLabel: refreshLabel ?? 'Refresh',
  );

  factory EmptyStateWidget.noSearchResults({
    String? query,
    VoidCallback? onClear,
  }) => EmptyStateWidget(
    icon: Icons.search_off_rounded,
    title: 'No Results',
    message: query != null
        ? 'No results found for "$query".'
        : 'No results found.',
    action: onClear,
    actionLabel: 'Clear Search',
  );

  factory EmptyStateWidget.noConnection({VoidCallback? onRetry}) =>
      EmptyStateWidget(
        icon: Icons.wifi_off_rounded,
        title: 'No Connection',
        message: 'Please check your internet connection and try again.',
        action: onRetry,
        actionLabel: 'Try Again',
      );

  factory EmptyStateWidget.comingSoon({String? feature}) => EmptyStateWidget(
    icon: Icons.rocket_launch_rounded,
    title: 'Coming Soon',
    message: feature != null
        ? '$feature is coming soon!'
        : 'This feature is coming soon!',
  );

  final String message;
  final String? title;
  final IconData? icon;
  final double iconSize;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: iconSize,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
          if (title != null) ...[
            const SizedBox(height: 16),
            Text(
              title!,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(onPressed: action, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
