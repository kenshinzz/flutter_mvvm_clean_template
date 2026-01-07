import 'package:dartz/dartz.dart';
import 'package:mvvm_clean_template/core/errors/exceptions.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/core/network/network_info.dart';
import 'package:mvvm_clean_template/data/datasources/user_local_datasource.dart';
import 'package:mvvm_clean_template/data/datasources/user_remote_datasource.dart';
import 'package:mvvm_clean_template/data/models/user_model.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';

/// Implementation of UserRepository
/// Handles data coordination between remote and local data sources
class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getCurrentUser();
        await _localDataSource.cacheCurrentUser(user);
        return Right(user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      final cachedUser = await _localDataSource.getCachedCurrentUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getUserById(id);
        await _localDataSource.cacheUser(user);
        return Right(user.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      final cachedUser = await _localDataSource.getCachedUser(id);
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final users = await _remoteDataSource.getUsers(
          page: page,
          limit: limit,
        );
        if (page == 1) {
          await _localDataSource.cacheUsers(users);
        }
        return Right(users.map((user) => user.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      if (page == 1) {
        final cachedUsers = await _localDataSource.getCachedUsers();
        if (cachedUsers != null) {
          return Right(cachedUsers.map((user) => user.toEntity()).toList());
        }
      }
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final userModel = UserModel.fromEntity(user);
      final updatedUser = await _remoteDataSource.updateUser(userModel);
      await _localDataSource.cacheUser(updatedUser);
      return Right(updatedUser.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.deleteUser(id);
      await _localDataSource.clearCache();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final users = await _remoteDataSource.searchUsers(query);
      return Right(users.map((user) => user.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
