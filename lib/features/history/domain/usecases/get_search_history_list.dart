import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

class GetSearchListHistory
    implements
        UseCaseExtend<List<SearchListModel>, ParamGetSearchHistoryRequests> {
  final SearchListRepository repository;

  GetSearchListHistory(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<SearchListModel>>> call(
      ParamGetSearchHistoryRequests param) async {
    return await repository.getSearchHistoryObjectList(
        param.tableName, param.pic1Map);
  }
}

class ParamGetSearchHistoryRequests extends Equatable {
  final String tableName;
  final Map<String, String> pic1Map;
  ParamGetSearchHistoryRequests(
      {required this.tableName, required this.pic1Map});

  @override
  List<Object> get props => [
        tableName,
      ];
}
