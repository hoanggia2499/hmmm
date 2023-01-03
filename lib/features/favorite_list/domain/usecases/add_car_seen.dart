import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/favorite_list/domain/repositories/favorite_list_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class AddCarSeenFavoriteList
    implements UseCaseExtend<void, ParamAddCarSeenFavoriteListRequests> {
  final FavoriteListRepository repository;

  AddCarSeenFavoriteList(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamAddCarSeenFavoriteListRequests param) async {
    return await repository.addCarObjectList(
        param.item, param.tableName, param.questionNo);
  }
}

class ParamAddCarSeenFavoriteListRequests extends Equatable {
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  ParamAddCarSeenFavoriteListRequests(this.item,
      {required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [tableName, questionNo, item];
}
