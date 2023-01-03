import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/message_board/domain/repositories/message_board_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../../../core/usecases/usecase_extend.dart';

class GetFavoriteListLocalMessageBoard
    implements
        UseCaseExtend<List<ItemSearchModel>,
            ParamGetFavoriteListLocalRequests> {
  final MessageBoardRepository repository;

  GetFavoriteListLocalMessageBoard(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> call(
      ParamGetFavoriteListLocalRequests param) async {
    return await repository.getFavoriteList(param.tableName, param.pic1Map);
  }
}

class ParamGetFavoriteListLocalRequests extends Equatable {
  final String tableName;
  final Map<String, String> pic1Map;

  ParamGetFavoriteListLocalRequests(
      {required this.tableName, required this.pic1Map});

  @override
  List<Object> get props => [tableName, pic1Map];
}
