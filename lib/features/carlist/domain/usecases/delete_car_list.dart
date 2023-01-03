import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/carlist/domain/repositories/carList_repository.dart';

class DeleteCarList implements UseCaseExtend<void, ParamDeleteRequests> {
  final CarListRepository repository;

  DeleteCarList(this.repository);

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
