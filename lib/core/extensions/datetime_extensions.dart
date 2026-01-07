import 'package:intl/intl.dart';

/// DateTime extension methods for common operations
extension DateTimeExtensions on DateTime {
  /// Format date as 'yyyy-MM-dd'
  String get toDateString => DateFormat('yyyy-MM-dd').format(this);

  /// Format date as 'yyyy-MM-dd HH:mm:ss'
  String get toDateTimeString => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);

  /// Format time as 'HH:mm:ss'
  String get toTimeString => DateFormat('HH:mm:ss').format(this);

  /// Format time as 'HH:mm'
  String get toShortTimeString => DateFormat('HH:mm').format(this);

  /// Format date as 'dd MMM yyyy' (e.g., 15 Jan 2024)
  String get toDisplayDate => DateFormat('dd MMM yyyy').format(this);

  /// Format date as 'dd MMM yyyy HH:mm' (e.g., 15 Jan 2024 14:30)
  String get toDisplayDateTime => DateFormat('dd MMM yyyy HH:mm').format(this);

  /// Format date as relative time (e.g., "2 hours ago", "Yesterday")
  String get toRelativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Format with custom pattern
  String format(String pattern) => DateFormat(pattern).format(this);

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if date is in the same week as now
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is in the same month as now
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is in the same year as now
  bool get isThisYear => year == DateTime.now().year;

  /// Get start of day (midnight)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  /// Get end of week (Sunday)
  DateTime get endOfWeek => add(Duration(days: 7 - weekday)).endOfDay;

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get age in years from this date
  int get age {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Add business days (skip weekends)
  DateTime addBusinessDays(int days) {
    var result = this;
    var remaining = days;
    while (remaining > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        remaining--;
      }
    }
    return result;
  }

  /// Check if same day as another date
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

/// Nullable DateTime extensions
extension NullableDateTimeExtensions on DateTime? {
  /// Format date or return default value
  String formatOrDefault(String pattern, {String defaultValue = '-'}) {
    if (this == null) return defaultValue;
    return DateFormat(pattern).format(this!);
  }

  /// Check if date is null or in the past
  bool get isNullOrPast => this == null || this!.isPast;
}
