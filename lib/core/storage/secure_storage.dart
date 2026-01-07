import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data like tokens
/// Uses platform-specific secure storage (Keychain on iOS, EncryptedSharedPreferences on Android)
abstract class SecureStorage {
  /// Store a value securely
  Future<void> write({required String key, required String value});

  /// Read a value
  Future<String?> read({required String key});

  /// Delete a value
  Future<void> delete({required String key});

  /// Delete all values
  Future<void> deleteAll();

  /// Check if key exists
  Future<bool> containsKey({required String key});
}

/// Implementation using flutter_secure_storage
class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? _defaultStorage;

  final FlutterSecureStorage _storage;

  // Android options for better compatibility
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
  );

  static const _defaultStorage = FlutterSecureStorage(
    aOptions: _androidOptions,
  );

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<bool> containsKey({required String key}) =>
      _storage.containsKey(key: key);
}

/// Storage keys for secure data
class SecureStorageKeys {
  SecureStorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String biometricEnabled = 'biometric_enabled';
  static const String pinCode = 'pin_code';
}
