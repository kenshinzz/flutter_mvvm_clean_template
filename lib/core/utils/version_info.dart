import 'package:package_info_plus/package_info_plus.dart';

/// Utility class for accessing app version information
class VersionInfo {
  VersionInfo._();

  static PackageInfo? _packageInfo;
  static bool _initialized = false;

  /// Initialize version info (call once at app startup)
  static Future<void> initialize() async {
    if (_initialized) return;
    _packageInfo = await PackageInfo.fromPlatform();
    _initialized = true;
  }

  /// Get the app version (e.g., "1.0.0")
  static String get version => _packageInfo?.version ?? '1.0.0';

  /// Get the build number (e.g., "1")
  static String get buildNumber => _packageInfo?.buildNumber ?? '1';

  /// Get the full version string (e.g., "1.0.0+1")
  static String get fullVersion => '$version+$buildNumber';

  /// Get the app name
  static String get appName => _packageInfo?.appName ?? 'App';

  /// Get the package name
  static String get packageName => _packageInfo?.packageName ?? '';

  /// Check if version info is initialized
  static bool get isInitialized => _initialized;

  /// Get version info as a map
  static Map<String, String> toMap() {
    return {
      'version': version,
      'buildNumber': buildNumber,
      'fullVersion': fullVersion,
      'appName': appName,
      'packageName': packageName,
    };
  }
}
