import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import '../../../../core/error/error_model.dart';

abstract class SearchDetailRepository {
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> getSeachDetail(
      SearchCarInputModel searchCarInputModel);
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getFavoriteList(
      String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<Either<ReponseErrorModel, void>> addFavorite(
      ItemSearchModel item, String tableName, String questionNo);
  Future<Either<ReponseErrorModel, String>> getFavoriteAccess(
      FavoriteAccessModel favoriteAccessModel);
}
