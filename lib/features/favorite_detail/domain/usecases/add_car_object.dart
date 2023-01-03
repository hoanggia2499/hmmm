import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/favorite_detail/domain/repositories/favorite_detail_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class AddCarSeenFavorite implements UseCaseExtend<void, ParamAddCarRequests> {
  final FavoriteDetailRepository repository;

  AddCarSeenFavorite(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamAddCarRequests param) async {
    return await repository.addCarObjectList(
        param.item, param.tableName, param.questionNo);
  }
}

class ParamAddCarRequests extends Equatable {
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  ParamAddCarRequests(
      {required this.item, required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [item, tableName, questionNo];
}
