/// List extension methods for common operations
extension ListExtensions<T> on List<T> {
  /// Get first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Find first element matching predicate or null
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Find last element matching predicate or null
  T? lastWhereOrNull(bool Function(T) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }

  /// Remove duplicates while preserving order
  List<T> distinct() {
    final seen = <T>{};
    return where(seen.add).toList();
  }

  /// Remove duplicates by key while preserving order
  List<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((element) => seen.add(keySelector(element))).toList();
  }

  /// Split list into chunks of given size
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Separate list into two lists based on predicate
  (List<T> matching, List<T> notMatching) partition(bool Function(T) test) {
    final matching = <T>[];
    final notMatching = <T>[];
    for (final element in this) {
      if (test(element)) {
        matching.add(element);
      } else {
        notMatching.add(element);
      }
    }
    return (matching, notMatching);
  }

  /// Group elements by key
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final result = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      (result[key] ??= []).add(element);
    }
    return result;
  }

  /// Sort and return new list (doesn't modify original)
  List<T> sorted([int Function(T, T)? compare]) => [...this]..sort(compare);

  /// Sort by key and return new list
  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keySelector) =>
      [...this]..sort((a, b) => keySelector(a).compareTo(keySelector(b)));

  /// Sort by key descending and return new list
  List<T> sortedByDescending<K extends Comparable<K>>(
    K Function(T) keySelector,
  ) => [...this]..sort((a, b) => keySelector(b).compareTo(keySelector(a)));

  /// Sum of elements (requires num type)
  num sum(num Function(T) selector) {
    num total = 0;
    for (final element in this) {
      total += selector(element);
    }
    return total;
  }

  /// Average of elements (requires num type)
  double average(num Function(T) selector) {
    if (isEmpty) return 0;
    return sum(selector) / length;
  }

  /// Max element by selector
  T? maxBy<K extends Comparable<K>>(K Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) > 0 ? a : b);
  }

  /// Min element by selector
  T? minBy<K extends Comparable<K>>(K Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) < 0 ? a : b);
  }

  /// Insert separator between elements
  List<T> separatedBy(T separator) {
    if (length <= 1) return [...this];
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) result.add(separator);
    }
    return result;
  }

  /// Map with index
  List<R> mapIndexed<R>(R Function(int index, T element) transform) {
    final result = <R>[];
    for (var i = 0; i < length; i++) {
      result.add(transform(i, this[i]));
    }
    return result;
  }

  /// For each with index
  void forEachIndexed(void Function(int index, T element) action) {
    for (var i = 0; i < length; i++) {
      action(i, this[i]);
    }
  }
}

/// Nullable list extensions
extension NullableListExtensions<T> on List<T>? {
  /// Check if null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Return empty list if null
  List<T> orEmpty() => this ?? [];
}
