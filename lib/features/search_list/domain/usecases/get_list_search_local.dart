import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

class GetListSearchLocal
    implements
        UseCaseExtend<List<CarSearchHive>, ParamGetCarSearchListRequests> {
  final SearchListRepository repository;

  GetListSearchLocal(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<CarSearchHive>>> call(
      ParamGetCarSearchListRequests param) async {
    return await repository.getCarListSearchFromHiveDb(param.tableName);
  }
}

class ParamGetCarSearchListRequests extends Equatable {
  final String tableName;

  ParamGetCarSearchListRequests({
    required this.tableName,
  });

  @override
  List<Object> get props => [
        tableName,
      ];
}
