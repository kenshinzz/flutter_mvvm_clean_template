import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';

/// Base class for all use cases
/// [T] is the return type
/// [Params] is the parameters type
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use this class when the use case doesn't require any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
