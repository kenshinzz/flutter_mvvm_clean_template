import 'package:intl/intl.dart';

/// Number extension methods for common operations
extension NumExtensions on num {
  /// Format as currency
  String toCurrency({
    String symbol = r'$',
    int decimalDigits = 2,
    String locale = 'en_US',
  }) => NumberFormat.currency(
    symbol: symbol,
    decimalDigits: decimalDigits,
    locale: locale,
  ).format(this);

  /// Format as compact number (e.g., 1.2K, 3.4M)
  String toCompact({String locale = 'en_US'}) =>
      NumberFormat.compact(locale: locale).format(this);

  /// Format with thousand separators
  String toFormatted({int decimalDigits = 0, String locale = 'en_US'}) =>
      NumberFormat.decimalPattern(locale).format(this);

  /// Format as percentage
  String toPercentage({int decimalDigits = 0}) =>
      '${(this * 100).toStringAsFixed(decimalDigits)}%';

  /// Format as file size
  String toFileSize({int decimalDigits = 1}) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(decimalDigits)} ${units[unitIndex]}';
  }

  /// Check if number is between min and max (inclusive)
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Clamp value between min and max
  num clampTo(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Convert to duration in milliseconds
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Convert to duration in seconds
  Duration get seconds => Duration(seconds: toInt());

  /// Convert to duration in minutes
  Duration get minutes => Duration(minutes: toInt());

  /// Convert to duration in hours
  Duration get hours => Duration(hours: toInt());

  /// Convert to duration in days
  Duration get days => Duration(days: toInt());
}

/// Integer extension methods
extension IntExtensions on int {
  /// Generate range list [0, 1, 2, ..., n-1]
  List<int> get range => List.generate(this, (i) => i);

  /// Ordinal suffix (1st, 2nd, 3rd, 4th, etc.)
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    return switch (this % 10) {
      1 => '${this}st',
      2 => '${this}nd',
      3 => '${this}rd',
      _ => '${this}th',
    };
  }

  /// Pad with leading zeros
  String padLeft(int width) => toString().padLeft(width, '0');
}

/// Double extension methods
extension DoubleExtensions on double {
  /// Round to specific decimal places
  double roundTo(int decimals) {
    final factor = 10 * decimals;
    return (this * factor).round() / factor;
  }

  /// Check if approximately equal to another double
  bool isApproximately(double other, {double epsilon = 0.0001}) =>
      (this - other).abs() < epsilon;
}
