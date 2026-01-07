import 'package:flutter/material.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/l10n/app_localizations.dart';

/// A customizable error widget with retry functionality
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message,
    this.failure,
    this.onRetry,
    this.icon,
    this.iconSize = 64.0,
    this.showRetryButton = true,
    this.retryButtonText,
  }) : assert(
         message != null || failure != null,
         'Either message or failure must be provided',
       );

  final String? message;
  final Failure? failure;
  final VoidCallback? onRetry;
  final IconData? icon;
  final double iconSize;
  final bool showRetryButton;
  final String? retryButtonText;

  /// Get appropriate icon based on failure type
  IconData _getIcon() {
    if (icon != null) return icon!;

    return switch (failure) {
      NetworkFailure() => Icons.wifi_off_rounded,
      ServerFailure() => Icons.cloud_off_rounded,
      AuthenticationFailure() => Icons.lock_outline_rounded,
      AuthorizationFailure() => Icons.block_rounded,
      NotFoundFailure() => Icons.search_off_rounded,
      _ => Icons.error_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final errorMessage = message ?? failure?.message ?? 'An error occurred';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIcon(),
            size: iconSize,
            color: theme.colorScheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryButtonText ?? l10n.tryAgain),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full screen error with retry
class FullScreenErrorWidget extends StatelessWidget {
  const FullScreenErrorWidget({
    super.key,
    this.message,
    this.failure,
    this.onRetry,
  });

  final String? message;
  final Failure? failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: AppErrorWidget(message: message, failure: failure, onRetry: onRetry),
  );
}
