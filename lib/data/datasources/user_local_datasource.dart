import 'dart:convert';

import 'package:mvvm_clean_template/core/errors/exceptions.dart';
import 'package:mvvm_clean_template/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source interface for user caching
abstract class UserLocalDataSource {
  /// Get cached current user
  Future<UserModel?> getCachedCurrentUser();

  /// Cache current user
  Future<void> cacheCurrentUser(UserModel user);

  /// Get cached user by ID
  Future<UserModel?> getCachedUser(String id);

  /// Cache user
  Future<void> cacheUser(UserModel user);

  /// Get cached users list
  Future<List<UserModel>?> getCachedUsers();

  /// Cache users list
  Future<void> cacheUsers(List<UserModel> users);

  /// Clear all cached users
  Future<void> clearCache();
}

/// Implementation of UserLocalDataSource using SharedPreferences
class UserLocalDataSourceImpl implements UserLocalDataSource {
  const UserLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _prefs = sharedPreferences;

  final SharedPreferences _prefs;

  static const String _currentUserKey = 'cached_current_user';
  static const String _usersKey = 'cached_users';
  static const String _userPrefix = 'cached_user_';

  @override
  Future<UserModel?> getCachedCurrentUser() async {
    final jsonString = _prefs.getString(_currentUserKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } on FormatException {
      throw CacheException('Failed to parse cached current user');
    }
  }

  @override
  Future<void> cacheCurrentUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await _prefs.setString(_currentUserKey, jsonString);
  }

  @override
  Future<UserModel?> getCachedUser(String id) async {
    final jsonString = _prefs.getString('$_userPrefix$id');
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } on FormatException {
      throw CacheException('Failed to parse cached user');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await _prefs.setString('$_userPrefix${user.id}', jsonString);
  }

  @override
  Future<List<UserModel>?> getCachedUsers() async {
    final jsonString = _prefs.getString(_usersKey);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw CacheException('Failed to parse cached users');
    }
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    final jsonList = users.map((user) => user.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_usersKey, jsonString);
  }

  @override
  Future<void> clearCache() async {
    final keys = _prefs.getKeys().where(
      (key) =>
          key == _currentUserKey ||
          key == _usersKey ||
          key.startsWith(_userPrefix),
    );

    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
