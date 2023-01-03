import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/history/domain/repositories/history_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class GetCarObjectListHistory
    implements
        UseCaseExtend<List<ItemSearchModel>, ParamGetCarListHistoryRequests> {
  final HistoryRepository repository;

  GetCarObjectListHistory(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> call(
      ParamGetCarListHistoryRequests param) async {
    return await repository.getCarObjectList(param.tableName, param.pic1Map);
  }
}

class ParamGetCarListHistoryRequests extends Equatable {
  final String tableName;
  final Map<String, String> pic1Map;

  ParamGetCarListHistoryRequests(
      {required this.tableName, required this.pic1Map});

  @override
  List<Object> get props => [tableName, pic1Map];
}
