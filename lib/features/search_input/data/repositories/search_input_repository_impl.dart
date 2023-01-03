import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/search_input/data/datasources/search_input_local_data_source.dart';
import 'package:mirukuru/features/search_input/domain/repositories/search_input_repository.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchInputRepositoryImpl implements SearchInputRepository {
  final SearchInputLocalDataSource searchInputLocalDataSource;
  SearchInputRepositoryImpl({required this.searchInputLocalDataSource});
  @override
  Future<Either<ReponseErrorModel, List<CarSearchHive>>>
      getCarListSearchFromHiveDb(String tableName) async {
    try {
      var result = await searchInputLocalDataSource
          .getCarListSearchFromHiveDb(tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> getNameBeanFromHiveDb(
      String tableName) async {
    try {
      var result =
          await searchInputLocalDataSource.getNameBeanFromHiveDb(tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
