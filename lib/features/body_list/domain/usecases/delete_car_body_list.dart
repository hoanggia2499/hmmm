import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/body_list/domain/repositories/body_list_repository.dart';

class DeleteCarBodyList implements UseCaseExtend<void, ParamDeleteRequests> {
  final BodyListRepository repository;

  DeleteCarBodyList(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamDeleteRequests param) async {
    return await repository.deleteCarListSearch(param.tableName);
  }
}

class ParamDeleteRequests extends Equatable {
  final String tableName;

  ParamDeleteRequests({required this.tableName});

  @override
  List<Object> get props => [tableName];
}
