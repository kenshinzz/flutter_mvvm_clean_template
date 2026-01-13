import 'package:speckit_flutter_template/core/storage/secure_storage.dart';

/// Authentication storage service for managing auth tokens
class AuthStorage {
  const AuthStorage({required SecureStorage secureStorage})
    : _storage = secureStorage;

  final SecureStorage _storage;

  /// Save access token
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: SecureStorageKeys.accessToken, value: token);

  /// Get access token
  Future<String?> getAccessToken() =>
      _storage.read(key: SecureStorageKeys.accessToken);

  /// Save refresh token
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: SecureStorageKeys.refreshToken, value: token);

  /// Get refresh token
  Future<String?> getRefreshToken() =>
      _storage.read(key: SecureStorageKeys.refreshToken);

  /// Save user ID
  Future<void> saveUserId(String userId) =>
      _storage.write(key: SecureStorageKeys.userId, value: userId);

  /// Get user ID
  Future<String?> getUserId() => _storage.read(key: SecureStorageKeys.userId);

  /// Save both tokens at once
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  /// Check if user is logged in (has access token)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all auth data (logout)
  Future<void> clearAuthData() async {
    await _storage.delete(key: SecureStorageKeys.accessToken);
    await _storage.delete(key: SecureStorageKeys.refreshToken);
    await _storage.delete(key: SecureStorageKeys.userId);
  }

  /// Clear all stored data
  Future<void> clearAll() => _storage.deleteAll();
}
