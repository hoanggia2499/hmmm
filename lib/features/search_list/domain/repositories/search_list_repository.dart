import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_car_pic1_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';
import '../../../../core/error/error_model.dart';
import '../../data/models/number_of_quotation_request.dart';

abstract class SearchListRepository {
  Future<Either<ReponseErrorModel, PaginatedDataModel<ItemSearchModel>>>
      getSearchList(SearchListModel searchListModel);
  Future<Either<ReponseErrorModel, List<ItemCarPic1Model>>> getCarPic1();

  Future<Either<ReponseErrorModel, String>> getNumberOfQuotationToday(
      NumberOfQuotationRequestModel request);

  Future<Either<ReponseErrorModel, String>> getFavoriteAccess(
      FavoriteAccessModel favoriteAccessModel);
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getCarObjectList(
      String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> removeCarObjectList(
      ItemSearchModel item, String tableName, String questionNo, int index);
  Future<Either<ReponseErrorModel, void>> addCarObjectList(
      ItemSearchModel item, String tableName, String questionNo);
  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<Either<ReponseErrorModel, List<CarSearchHive>>>
      getCarListSearchFromHiveDb(String tableName);
  Future<Either<ReponseErrorModel, List<SearchListModel>>>
      getSearchHistoryObjectList(String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> updateSearchHistoryObjectList(
      int index, String tableName);
  Future<Either<ReponseErrorModel, void>> addSearchHistoryObjectList(
      SearchListModel element, String tableName);
}
