import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/carlist/domain/repositories/carList_repository.dart';

class AddAllCarList implements UseCaseExtend<void, ParamRequests> {
  final CarListRepository repository;

  AddAllCarList(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(ParamRequests param) async {
    return await repository.addAllCarListSearchToHiveDb(
        param.carSearchList, param.tableName);
  }
}

class ParamRequests extends Equatable {
  final List<CarSearchHive> carSearchList;
  final String tableName;

  ParamRequests({required this.carSearchList, required this.tableName});

  @override
  List<Object> get props => [carSearchList, tableName];
}
