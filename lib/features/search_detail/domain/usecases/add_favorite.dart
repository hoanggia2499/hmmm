import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_detail/domain/repositories/search_detail_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class AddFavoriteSearchDetail
    implements UseCaseExtend<void, ParamAddFavoriteSearchDetailRequests> {
  final SearchDetailRepository repository;

  AddFavoriteSearchDetail(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamAddFavoriteSearchDetailRequests param) async {
    return await repository.addFavorite(
        param.item, param.tableName, param.questionNo);
  }
}

class ParamAddFavoriteSearchDetailRequests extends Equatable {
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  ParamAddFavoriteSearchDetailRequests(this.item,
      {required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [tableName, questionNo, item];
}
