import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/carlist/data/datasources/car_list_local_data_source.dart';
import 'package:mirukuru/features/carlist/data/datasources/car_list_remote_data_source.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/carlist/domain/repositories/carList_repository.dart';
import 'package:mirukuru/features/carlist/domain/usecases/get_carList.dart';

import '../../../../core/error/exceptions.dart';

class CarListRepositoryImpl implements CarListRepository {
  final CarListRemoteDataSource carListRemoteDataSource;
  final CarListLocalDataSource carListLocalDataSource;
  CarListRepositoryImpl({
    required this.carListLocalDataSource,
    required this.carListRemoteDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, List<CarModel>>> getCarList(
      ParamCarListRequests param) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await carListRemoteDataSource.getCarList(param);
        return Right(result!);
      } on ServerException catch (error) {
        return Left(
            ReponseErrorModel(msgCode: error.code, msgContent: error.content));
      } on Exception {
        return Left(ReponseErrorModel(
            msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
      }
    } else {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> addAllCarListSearchToHiveDb(
      List<CarSearchHive> carSearchList, String tableName) async {
    try {
      var result = await carListLocalDataSource.addAllCarListSearchToHiveDb(
          carSearchList, tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> deleteCarListSearch(
      String tableName) async {
    try {
      var result = await carListLocalDataSource.deleteCarListSearch(tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> addCarListSearch(
      CarSearchHive carSearchHive, String tableName) async {
    try {
      var result = await carListLocalDataSource.addCarListSearch(
          carSearchHive, tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
