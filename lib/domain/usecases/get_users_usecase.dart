import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/core/usecases/usecase.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';

/// Use case to get paginated list of users
class GetUsersUseCase implements UseCase<List<UserEntity>, GetUsersParams> {
  const GetUsersUseCase({required UserRepository repository})
    : _repository = repository;

  final UserRepository _repository;

  @override
  Future<Either<Failure, List<UserEntity>>> call(GetUsersParams params) =>
      _repository.getUsers(page: params.page, limit: params.limit);
}

/// Parameters for GetUsersUseCase
class GetUsersParams extends Equatable {
  const GetUsersParams({this.page = 1, this.limit = 20});

  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}
