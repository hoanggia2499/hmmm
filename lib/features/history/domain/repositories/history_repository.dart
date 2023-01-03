import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

import '../../../search_list/data/models/favorite_access_model.dart';

abstract class HistoryRepository {
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getItemHistoryList();
  Future<Either<ReponseErrorModel, List<SearchListModel>>> getSearchInputList();
  Future<Either<ReponseErrorModel, void>> addItemHistory(ItemSearchModel item);
  Future<Either<ReponseErrorModel, void>> addSearchInputHistory(
      SearchListModel item);
  Future<Either<ReponseErrorModel, String>> getFavoriteAccess(
      FavoriteAccessModel favoriteAccessModel);
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getCarObjectList(
      String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> addCarObjectList(
      ItemSearchModel item, String tableName, String questionNo);
  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<Either<ReponseErrorModel, List<SearchListModel>>>
      getSearchHistoryObjectList(String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> removeCarObjectList(
      ItemSearchModel item, String tableName, String questionNo, int index);
}
