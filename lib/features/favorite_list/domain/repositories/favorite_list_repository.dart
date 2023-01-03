import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../../../core/error/error_model.dart';
import '../../../search_list/data/models/item_car_pic1_model.dart';

abstract class FavoriteListRepository {
  Future<Either<ReponseErrorModel, String>> getFavoriteList();
  Future<Either<ReponseErrorModel, List<ItemCarPic1Model>>> getCarPic1();
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getCarObjectList(
      String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<Either<ReponseErrorModel, void>> addCarObjectList(
      ItemSearchModel item, String tableName, String questionNo);
  Future<Either<ReponseErrorModel, void>> removeCarObjectList(
      String tableName, int index);
}
