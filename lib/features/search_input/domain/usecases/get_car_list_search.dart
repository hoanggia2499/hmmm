import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_input/domain/repositories/search_input_repository.dart';

class GetCarListSearchFavorite
    implements
        UseCaseExtend<List<CarSearchHive>, ParamCarListSearchFavoriteRequests> {
  final SearchInputRepository repository;

  GetCarListSearchFavorite(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<CarSearchHive>>> call(
      ParamCarListSearchFavoriteRequests param) async {
    return await repository.getCarListSearchFromHiveDb(param.tableName);
  }
}

class ParamCarListSearchFavoriteRequests extends Equatable {
  final String tableName;
  ParamCarListSearchFavoriteRequests({
    required this.tableName,
  });

  @override
  List<Object> get props => [tableName];
}
