import 'package:dartz/dartz.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';

/// User repository interface - defines the contract for data operations
/// This is part of the domain layer, implementation is in data layer
abstract class UserRepository {
  /// Get the current authenticated user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Get user by ID
  Future<Either<Failure, UserEntity>> getUserById(String id);

  /// Get list of users with optional pagination
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int limit = 20,
  });

  /// Update user profile
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);

  /// Delete user account
  Future<Either<Failure, void>> deleteUser(String id);

  /// Search users by query
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
}
