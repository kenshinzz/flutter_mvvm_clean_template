import 'package:equatable/equatable.dart';
import 'package:speckit_flutter_template/core/errors/failures.dart';

/// State for handling paginated data loading
class PaginationState<T> extends Equatable {
  const PaginationState({
    this.items = const [],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.failure,
  });

  /// Initial state
  factory PaginationState.initial() => const PaginationState();

  final List<T> items;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? failure;

  /// Loading first page
  PaginationState<T> loading() => PaginationState<T>(
    items: items,
    currentPage: currentPage,
    hasMore: hasMore,
    isLoading: true,
  );

  /// Loading more items
  PaginationState<T> loadingMore() => PaginationState<T>(
    items: items,
    currentPage: currentPage,
    hasMore: hasMore,
    isLoadingMore: true,
  );

  /// Success with new items
  PaginationState<T> success({
    required List<T> newItems,
    required bool hasMore,
    bool append = true,
  }) => PaginationState<T>(
    items: append ? [...items, ...newItems] : newItems,
    currentPage: currentPage + 1,
    hasMore: hasMore,
  );

  /// Error state
  PaginationState<T> error(Failure failure) => PaginationState<T>(
    items: items,
    currentPage: currentPage,
    hasMore: hasMore,
    failure: failure,
  );

  /// Reset to initial state
  PaginationState<T> reset() => PaginationState<T>.initial();

  /// Check if should load more
  bool get canLoadMore => hasMore && !isLoading && !isLoadingMore;

  /// Check if list is empty and not loading
  bool get isEmpty => items.isEmpty && !isLoading && !isLoadingMore;

  /// Check if has error
  bool get hasError => failure != null;

  @override
  List<Object?> get props => [
    items,
    currentPage,
    hasMore,
    isLoading,
    isLoadingMore,
    failure,
  ];
}
