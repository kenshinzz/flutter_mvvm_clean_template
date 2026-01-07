/// Environment types supported by the app
enum Environment { dev, staging, prod }

/// Environment configuration that holds all environment-specific values
/// Configure these values based on your environment
enum EnvConfig {
  /// Development environment configuration
  dev._(
    environment: Environment.dev,
    apiBaseUrl: 'https://dev-api.example.com',
    apiVersion: 'v1',
    enableLogging: true,
    enableCrashlytics: false,
    connectionTimeout: 30000,
    receiveTimeout: 30000,
  ),

  /// Staging environment configuration
  staging._(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.example.com',
    apiVersion: 'v1',
    enableLogging: true,
    enableCrashlytics: true,
    connectionTimeout: 30000,
    receiveTimeout: 30000,
  ),

  /// Production environment configuration
  prod._(
    environment: Environment.prod,
    apiBaseUrl: 'https://api.example.com',
    apiVersion: 'v1',
    enableLogging: false,
    enableCrashlytics: true,
    connectionTimeout: 30000,
    receiveTimeout: 30000,
  );

  const EnvConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiVersion,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.connectionTimeout,
    required this.receiveTimeout,
  });
  final Environment environment;
  final String apiBaseUrl;
  final String apiVersion;
  final bool enableLogging;
  final bool enableCrashlytics;
  final int connectionTimeout;
  final int receiveTimeout;

  /// Get configuration by environment
  static EnvConfig getConfig(Environment env) {
    switch (env) {
      case Environment.dev:
        return dev;
      case Environment.staging:
        return staging;
      case Environment.prod:
        return prod;
    }
  }

  /// Check if current environment is development
  bool get isDev => environment == Environment.dev;

  /// Check if current environment is staging
  bool get isStaging => environment == Environment.staging;

  /// Check if current environment is production
  bool get isProd => environment == Environment.prod;

  /// Full API URL with version
  String get fullApiUrl => '$apiBaseUrl/$apiVersion';
}
