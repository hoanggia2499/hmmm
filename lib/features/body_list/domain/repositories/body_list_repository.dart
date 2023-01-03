import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';

abstract class BodyListRepository {
  Future<Either<ReponseErrorModel, List<BodyModel>>> getBodyList(int id);
  Future<Either<ReponseErrorModel, void>> addAllCarListSearchToHiveDb(
      List<CarSearchHive> carSearchList, String tableName);
  Future<Either<ReponseErrorModel, void>> deleteCarListSearch(String tableName);
  Future<Either<ReponseErrorModel, void>> addCarListSearch(
      CarSearchHive carSearchHive, String tableName);
}
