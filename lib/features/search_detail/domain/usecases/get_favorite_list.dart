import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_detail/domain/repositories/search_detail_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class GetFavoriteListSeachDetail
    implements
        UseCaseExtend<List<ItemSearchModel>,
            ParamGetFavoriteListSeachDetailRequests> {
  final SearchDetailRepository repository;

  GetFavoriteListSeachDetail(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> call(
      ParamGetFavoriteListSeachDetailRequests param) async {
    return await repository.getFavoriteList(param.tableName, param.pic1Map);
  }
}

class ParamGetFavoriteListSeachDetailRequests extends Equatable {
  final String tableName;
  final Map<String, String> pic1Map;

  ParamGetFavoriteListSeachDetailRequests(
      {required this.tableName, required this.pic1Map});

  @override
  List<Object> get props => [tableName, pic1Map];
}
