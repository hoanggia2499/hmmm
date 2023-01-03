import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/history/data/datasources/history_local_data_source.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/util/connection_util.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;
  final HistoryRemoteDataSource historyRemoteDataSource;

  HistoryRepositoryImpl(this.localDataSource, this.historyRemoteDataSource);

  @override
  Future<Either<ReponseErrorModel, void>> addItemHistory(
      ItemSearchModel item) async {
    try {
      var result = await localDataSource.addItemHistory(item);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, void>> addSearchInputHistory(
      SearchListModel item) async {
    try {
      var result = await localDataSource.addSearchInputHistory(item);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>>
      getItemHistoryList() async {
    try {
      var result = await localDataSource.getItemHistoryList();
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, List<SearchListModel>>>
      getSearchInputList() async {
    try {
      var result = await localDataSource.getSearchInputList();
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, String>> getFavoriteAccess(
      FavoriteAccessModel favoriteAccessModel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await historyRemoteDataSource
            .getFavoriteAccess(favoriteAccessModel);
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
      var result = await localDataSource.getCarObjectList(tableName, pic1Map);
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
      var result =
          await localDataSource.addCarObjectList(item, tableName, questionNo);
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
      var result = await localDataSource.deleteFavoriteObjectListByPosition(
          tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, List<SearchListModel>>>
      getSearchHistoryObjectList(
          String tableName, Map<String, String> pic1Map) async {
    try {
      var result =
          await localDataSource.getSearchHistoryObjectList(tableName, pic1Map);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> removeCarObjectList(
      ItemSearchModel item,
      String tableName,
      String questionNo,
      int index) async {
    try {
      var result = await localDataSource.removeCarObjectList(
          item, tableName, questionNo, index);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
