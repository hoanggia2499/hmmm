import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/history/domain/repositories/history_repository.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

class GetSearchInputHistoryList
    extends UseCaseExtend<List<SearchListModel>, NoParamsExt> {
  final HistoryRepository repository;

  GetSearchInputHistoryList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<SearchListModel>>> call(
      NoParamsExt params) async {
    return await repository.getSearchInputList();
  }
}
