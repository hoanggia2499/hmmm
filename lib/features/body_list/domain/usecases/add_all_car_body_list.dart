import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/body_list/domain/repositories/body_list_repository.dart';

class AddAllCarBodyList implements UseCaseExtend<void, ParamRequests> {
  final BodyListRepository repository;

  AddAllCarBodyList(this.repository);

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
