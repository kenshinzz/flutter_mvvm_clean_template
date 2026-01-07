import 'package:dartz/dartz.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/core/usecases/usecase.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';

/// Use case to update user profile
class UpdateUserUseCase implements UseCase<UserEntity, UserEntity> {
  const UpdateUserUseCase({required UserRepository repository})
    : _repository = repository;

  final UserRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity params) =>
      _repository.updateUser(params);
}
