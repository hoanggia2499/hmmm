import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/history/domain/repositories/history_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class GetItemSearchHistoryList
    extends UseCaseExtend<List<ItemSearchModel>, NoParamsExt> {
  final HistoryRepository repository;

  GetItemSearchHistoryList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> call(
      NoParamsExt params) async {
    return await repository.getItemHistoryList();
  }
}
