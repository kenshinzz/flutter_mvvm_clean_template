import 'package:intl/intl.dart';
import 'package:speckit_flutter_template/core/constants/app_constants.dart';

class AppDateUtils {
  AppDateUtils._();

  // Format date to string
  static String formatDate(DateTime date, {String format = AppConstants.displayDateFormat}) => DateFormat(format).format(date);

  // Format datetime to string
  static String formatDateTime(DateTime dateTime, {String format = AppConstants.displayDateTimeFormat}) => DateFormat(format).format(dateTime);

  // Format time to string
  static String formatTime(DateTime time, {String format = AppConstants.timeFormat}) => DateFormat(format).format(time);

  // Parse string to date
  static DateTime? parseDate(String dateString, {String format = AppConstants.dateFormat}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse string to datetime
  static DateTime? parseDateTime(String dateTimeString, {String format = AppConstants.dateTimeFormat}) {
    try {
      return DateFormat(format).parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  // Get time ago string (e.g., "2 hours ago")
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  // Check if date is in current week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  // Get start of day
  static DateTime getStartOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  // Get end of day
  static DateTime getEndOfDay(DateTime date) => DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  // Get start of month
  static DateTime getStartOfMonth(DateTime date) => DateTime(date.year, date.month);

  // Get end of month
  static DateTime getEndOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);

  // Add days to date
  static DateTime addDays(DateTime date, int days) => date.add(Duration(days: days));

  // Subtract days from date
  static DateTime subtractDays(DateTime date, int days) => date.subtract(Duration(days: days));

  // Get difference in days
  static int getDifferenceInDays(DateTime start, DateTime end) {
    final startDate = getStartOfDay(start);
    final endDate = getStartOfDay(end);
    return endDate.difference(startDate).inDays;
  }

  // Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) => date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}
