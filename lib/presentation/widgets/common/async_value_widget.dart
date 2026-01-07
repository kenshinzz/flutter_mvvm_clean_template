import 'package:flutter/material.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/core/state/async_state.dart';
import 'package:mvvm_clean_template/presentation/widgets/common/empty_state_widget.dart';
import 'package:mvvm_clean_template/presentation/widgets/common/error_widget.dart';
import 'package:mvvm_clean_template/presentation/widgets/common/loading_widget.dart';

/// Widget that handles AsyncState rendering with customizable builders
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.state,
    required this.onData,
    super.key,
    this.onLoading,
    this.onError,
    this.onInitial,
    this.onRetry,
    this.showEmptyState = true,
    this.emptyStateBuilder,
    this.loadingMessage,
  });

  final AsyncState<T> state;
  final Widget Function(T data) onData;
  final Widget Function()? onLoading;
  final Widget Function(Failure failure)? onError;
  final Widget Function()? onInitial;
  final VoidCallback? onRetry;
  final bool showEmptyState;
  final Widget Function()? emptyStateBuilder;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) => state.when(
    initial: () => onInitial?.call() ?? const SizedBox.shrink(),
    loading: () =>
        onLoading?.call() ??
        Center(child: LoadingWidget(message: loadingMessage)),
    success: (data) {
      // Handle empty list case
      if (showEmptyState && data is List && (data as List).isEmpty) {
        return emptyStateBuilder?.call() ?? EmptyStateWidget.noData();
      }
      return onData(data);
    },
    error: (failure) =>
        onError?.call(failure) ??
        Center(
          child: AppErrorWidget(failure: failure, onRetry: onRetry),
        ),
  );
}

/// Sliver version for use in CustomScrollView
class SliverAsyncValueWidget<T> extends StatelessWidget {
  const SliverAsyncValueWidget({
    required this.state,
    required this.onData,
    super.key,
    this.onLoading,
    this.onError,
    this.onRetry,
    this.loadingMessage,
  });

  final AsyncState<T> state;
  final Widget Function(T data) onData;
  final Widget Function()? onLoading;
  final Widget Function(Failure failure)? onError;
  final VoidCallback? onRetry;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) => state.when(
    initial: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
    loading: () => SliverFillRemaining(
      child:
          onLoading?.call() ??
          Center(child: LoadingWidget(message: loadingMessage)),
    ),
    success: onData,
    error: (failure) => SliverFillRemaining(
      child:
          onError?.call(failure) ??
          Center(
            child: AppErrorWidget(failure: failure, onRetry: onRetry),
          ),
    ),
  );
}
