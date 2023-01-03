import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/carlist/domain/usecases/get_carList.dart';

abstract class CarListRepository {
  Future<Either<ReponseErrorModel, List<CarModel>>> getCarList(
      ParamCarListRequests param);
  Future<Either<ReponseErrorModel, void>> addAllCarListSearchToHiveDb(
      List<CarSearchHive> carSearchList, String tableName);
  Future<Either<ReponseErrorModel, void>> deleteCarListSearch(String tableName);
  Future<Either<ReponseErrorModel, void>> addCarListSearch(
      CarSearchHive carSearchHive, String tableName);
}
