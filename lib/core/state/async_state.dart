import 'package:equatable/equatable.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';

/// Generic async state for handling loading, success, and error states
/// Use this in ViewModels to manage async operations
sealed class AsyncState<T> extends Equatable {
  const AsyncState();

  /// Initial state before any data is loaded
  const factory AsyncState.initial() = AsyncStateInitial<T>;

  /// Loading state while data is being fetched
  const factory AsyncState.loading() = AsyncStateLoading<T>;

  /// Success state with data
  const factory AsyncState.success(T data) = AsyncStateSuccess<T>;

  /// Error state with failure information
  const factory AsyncState.error(Failure failure) = AsyncStateError<T>;

  /// Pattern matching helper
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) => switch (this) {
    AsyncStateInitial<T>() => initial(),
    AsyncStateLoading<T>() => loading(),
    AsyncStateSuccess<T>(data: final data) => success(data),
    AsyncStateError<T>(failure: final failure) => error(failure),
  };

  /// Pattern matching with default fallback
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(Failure failure)? error,
  }) => switch (this) {
    AsyncStateInitial<T>() => initial?.call() ?? orElse(),
    AsyncStateLoading<T>() => loading?.call() ?? orElse(),
    AsyncStateSuccess<T>(data: final data) => success?.call(data) ?? orElse(),
    AsyncStateError<T>(failure: final failure) =>
      error?.call(failure) ?? orElse(),
  };

  /// Convenience getters
  bool get isInitial => this is AsyncStateInitial<T>;
  bool get isLoading => this is AsyncStateLoading<T>;
  bool get isSuccess => this is AsyncStateSuccess<T>;
  bool get isError => this is AsyncStateError<T>;

  /// Get data if in success state, otherwise null
  T? get dataOrNull =>
      this is AsyncStateSuccess<T> ? (this as AsyncStateSuccess<T>).data : null;

  /// Get failure if in error state, otherwise null
  Failure? get failureOrNull =>
      this is AsyncStateError<T> ? (this as AsyncStateError<T>).failure : null;
}

/// Initial state
final class AsyncStateInitial<T> extends AsyncState<T> {
  const AsyncStateInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state
final class AsyncStateLoading<T> extends AsyncState<T> {
  const AsyncStateLoading();

  @override
  List<Object?> get props => [];
}

/// Success state with data
final class AsyncStateSuccess<T> extends AsyncState<T> {
  const AsyncStateSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

/// Error state with failure
final class AsyncStateError<T> extends AsyncState<T> {
  const AsyncStateError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
