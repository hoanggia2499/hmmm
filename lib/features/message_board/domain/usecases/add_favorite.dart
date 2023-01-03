import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/message_board/domain/repositories/message_board_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class AddFavoriteMessageBoard
    implements UseCaseExtend<void, ParamAddFavoriteListRequests> {
  final MessageBoardRepository repository;

  AddFavoriteMessageBoard(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamAddFavoriteListRequests param) async {
    return await repository.addFavorite(
        param.item, param.tableName, param.questionNo);
  }
}

class ParamAddFavoriteListRequests extends Equatable {
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  ParamAddFavoriteListRequests(this.item,
      {required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [tableName, questionNo, item];
}
