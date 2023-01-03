import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

import '../../../../core/error/error_model.dart';

class GetSearchList
    implements
        UseCaseExtend<PaginatedDataModel<ItemSearchModel>, SearchListModel> {
  final SearchListRepository repository;

  GetSearchList(this.repository);

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<ItemSearchModel>>> call(
      SearchListModel params) async {
    return await repository.getSearchList(params);
  }
}
