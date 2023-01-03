import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/favorite_list/data/datasources/favorite_list_local_data_source.dart';
import 'package:mirukuru/features/favorite_list/data/datasources/favorite_list_remote_data_source.dart';
import 'package:mirukuru/features/favorite_list/domain/repositories/favorite_list_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../../../core/util/error_code.dart';
import '../../../search_list/data/models/item_car_pic1_model.dart';

class FavoriteListRepositoryImpl implements FavoriteListRepository {
  final FavoriteListDataSource favoriteListDataSource;
  final FavoriteListLocalDataSource favoriteListLocalDataSource;
  FavoriteListRepositoryImpl(
      {required this.favoriteListDataSource,
      required this.favoriteListLocalDataSource});

  @override
  Future<Either<ReponseErrorModel, String>> getFavoriteList() async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await favoriteListDataSource.getFavoriteList();
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

  @override
  Future<Either<ReponseErrorModel, List<ItemCarPic1Model>>> getCarPic1() async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await favoriteListDataSource.getCarPic1();
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

  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getCarObjectList(
      String tableName, Map<String, String> pic1Map) async {
    try {
      var result = await favoriteListLocalDataSource.getCarObjectList(
          tableName, pic1Map);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo) async {
    try {
      var result = await favoriteListLocalDataSource
          .deleteFavoriteObjectListByPosition(tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> addCarObjectList(
      ItemSearchModel item, String tableName, String questionNo) async {
    try {
      var result = await favoriteListLocalDataSource.addCarObjectList(
          item, tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> removeCarObjectList(
      String tableName, int index) async {
    try {
      var result = await favoriteListLocalDataSource.removeCarObjectList(
          tableName, index);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
