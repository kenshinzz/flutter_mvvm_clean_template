/// String extension methods for common operations
extension StringExtensions on String {
  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Check if string contains only digits
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only letters and digits
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Capitalize first letter
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalize first letter of each word
  String get capitalizeWords =>
      split(' ').map((word) => word.capitalize).join(' ');

  /// Convert to title case
  String get toTitleCase => toLowerCase().capitalizeWords;

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Convert camelCase to snake_case
  String get toSnakeCase => replaceAllMapped(
    RegExp('([A-Z])'),
    (match) => '_${match.group(1)!.toLowerCase()}',
  ).replaceFirst(RegExp('^_'), '');

  /// Convert snake_case to camelCase
  String get toCamelCase => replaceAllMapped(
    RegExp('_([a-z])'),
    (match) => match.group(1)!.toUpperCase(),
  );

  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Returns null if empty, otherwise returns the string
  String? get nullIfEmpty => isEmpty ? null : this;

  /// Convert to int or return null
  int? toIntOrNull() => int.tryParse(this);

  /// Convert to double or return null
  double? toDoubleOrNull() => double.tryParse(this);

  /// Mask string for privacy (e.g., email: j***@example.com)
  String maskEmail() {
    if (!contains('@')) return this;
    final parts = split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return this;
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  /// Mask phone number (e.g., +1 *** *** 1234)
  String maskPhone({int visibleEnd = 4}) {
    if (length <= visibleEnd) return this;
    return '${'*' * (length - visibleEnd)}${substring(length - visibleEnd)}';
  }
}

/// Nullable string extensions
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Return default value if null or empty
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;
}
