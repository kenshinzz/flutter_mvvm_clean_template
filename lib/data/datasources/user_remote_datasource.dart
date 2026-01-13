import 'package:speckit_flutter_template/core/errors/exceptions.dart';
import 'package:speckit_flutter_template/core/network/api_client.dart';
import 'package:speckit_flutter_template/data/models/user_model.dart';

/// Remote data source interface for user operations
abstract class UserRemoteDataSource {
  /// Get current authenticated user from API
  Future<UserModel> getCurrentUser();

  /// Get user by ID from API
  Future<UserModel> getUserById(String id);

  /// Get paginated list of users from API
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20});

  /// Update user profile via API
  Future<UserModel> updateUser(UserModel user);

  /// Delete user via API
  Future<void> deleteUser(String id);

  /// Search users via API
  Future<List<UserModel>> searchUsers(String query);
}

/// Implementation of UserRemoteDataSource
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get('/users/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final response = await _apiClient.get('/users/$id');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<UserModel>> getUsers({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '/users',
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = response.data as Map<String, dynamic>;
    final users = data['users'] as List<dynamic>? ?? [];

    return users
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final response = await _apiClient.put(
      '/users/${user.id}',
      data: user.toJson(),
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _apiClient.delete('/users/$id');
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) {
      throw ValidationException('Search query cannot be empty');
    }

    final response = await _apiClient.get(
      '/users/search',
      queryParameters: {'q': query},
    );

    final data = response.data as Map<String, dynamic>;
    final users = data['users'] as List<dynamic>? ?? [];

    return users
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
