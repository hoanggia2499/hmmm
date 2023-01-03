import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/history/domain/repositories/history_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class RemoveCarHistory
    implements UseCaseExtend<void, ParamRemoveCarHistoryRequests> {
  final HistoryRepository repository;

  RemoveCarHistory(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamRemoveCarHistoryRequests param) async {
    return await repository.removeCarObjectList(
        param.item, param.tableName, param.questionNo, param.index);
  }
}

class ParamRemoveCarHistoryRequests extends Equatable {
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;
  final int index;

  ParamRemoveCarHistoryRequests(
      {required this.item,
      required this.tableName,
      required this.questionNo,
      required this.index});

  @override
  List<Object> get props => [item, tableName, questionNo, index];
}
