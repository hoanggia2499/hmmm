import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/favorite_detail/domain/repositories/favorite_detail_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class GetCarSeenFavoriteObjectList
    implements UseCaseExtend<List<ItemSearchModel>, ParamGetCarListRequests> {
  final FavoriteDetailRepository repository;

  GetCarSeenFavoriteObjectList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> call(
      ParamGetCarListRequests param) async {
    return await repository.getCarObjectList(param.tableName, param.pic1Map);
  }
}

class ParamGetCarListRequests extends Equatable {
  final String tableName;
  final Map<String, String> pic1Map;

  ParamGetCarListRequests({required this.tableName, required this.pic1Map});

  @override
  List<Object> get props => [tableName, pic1Map];
}
