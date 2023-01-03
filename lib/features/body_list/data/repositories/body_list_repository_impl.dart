import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/body_list/data/datasources/body_list_local_data_source.dart';
import 'package:mirukuru/features/body_list/data/datasources/body_list_remote_data_source.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';
import 'package:mirukuru/features/body_list/domain/repositories/body_list_repository.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';

class BodyListRepositoryImpl implements BodyListRepository {
  final BodyListRemoteDataSource bodyListRemoteDataSource;
  final BodyListLocalDataSource bodyListLocalDataSource;
  BodyListRepositoryImpl(
      {required this.bodyListRemoteDataSource,
      required this.bodyListLocalDataSource});

  @override
  Future<Either<ReponseErrorModel, List<BodyModel>>> getBodyList(int id) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await bodyListRemoteDataSource.getBodyList(id);
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
      var result = await bodyListLocalDataSource.addAllCarListSearchToHiveDb(
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
      var result = await bodyListLocalDataSource.deleteCarListSearch(tableName);
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
      var result = await bodyListLocalDataSource.addCarListSearch(
          carSearchHive, tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
