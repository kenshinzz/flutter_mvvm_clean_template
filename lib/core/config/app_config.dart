import 'env_config.dart';

/// Global app configuration singleton
/// Access current environment config from anywhere in the app
class AppConfig {
  AppConfig._();
  static AppConfig? _instance;
  static late EnvConfig _envConfig;

  /// Initialize app configuration with the specified environment
  /// Call this in main() before runApp()
  static void init(Environment environment) {
    _instance ??= AppConfig._();
    _envConfig = EnvConfig.getConfig(environment);
  }

  /// Get the singleton instance
  static AppConfig get instance {
    if (_instance == null) {
      throw Exception(
        'AppConfig not initialized. Call AppConfig.init() first.',
      );
    }
    return _instance!;
  }

  /// Get current environment configuration
  static EnvConfig get env => _envConfig;

  /// Convenience getters
  static String get apiBaseUrl => _envConfig.apiBaseUrl;
  static String get apiVersion => _envConfig.apiVersion;
  static String get fullApiUrl => _envConfig.fullApiUrl;
  static bool get enableLogging => _envConfig.enableLogging;
  static bool get enableCrashlytics => _envConfig.enableCrashlytics;
  static int get connectionTimeout => _envConfig.connectionTimeout;
  static int get receiveTimeout => _envConfig.receiveTimeout;
  static bool get isDev => _envConfig.isDev;
  static bool get isStaging => _envConfig.isStaging;
  static bool get isProd => _envConfig.isProd;
}
