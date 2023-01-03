import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import '../../../../core/error/error_model.dart';

abstract class SearchInputRepository {
  Future<Either<ReponseErrorModel, List<CarSearchHive>>>
      getCarListSearchFromHiveDb(String tableName);
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> getNameBeanFromHiveDb(
      String tableName);
}
