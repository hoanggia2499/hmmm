import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/error_model.dart';

abstract class UseCaseExtend<Type, Params> {
  Future<Either<ReponseErrorModel, Type>> call(Params params);
}

class NoParamsExt extends Equatable {
  @override
  List<Object> get props => [];
}
