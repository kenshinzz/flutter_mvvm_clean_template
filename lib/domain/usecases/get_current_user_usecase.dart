import 'package:dartz/dartz.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/core/usecases/usecase.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';

/// Use case to get the current authenticated user
class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  const GetCurrentUserUseCase({required UserRepository repository})
    : _repository = repository;

  final UserRepository _repository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) =>
      _repository.getCurrentUser();
}
