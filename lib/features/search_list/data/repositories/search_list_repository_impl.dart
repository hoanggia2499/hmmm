import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/search_list/data/datasources/search_list_local_data_source.dart';
import 'package:mirukuru/features/search_list/data/datasources/search_list_remote_data_source.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_car_pic1_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../models/number_of_quotation_request.dart';

class SearchListRepositoryImpl implements SearchListRepository {
  final SearchListRemoteDataSource searchListRemoteDataSource;
  final SearchListLocalDataSource searchListLocalDataSource;
  SearchListRepositoryImpl(
      {required this.searchListRemoteDataSource,
      required this.searchListLocalDataSource});

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<ItemSearchModel>>>
      getSearchList(SearchListModel searchListModel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await searchListRemoteDataSource.getSearchList(searchListModel);

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
        var result = await searchListRemoteDataSource.getCarPic1();
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
  Future<Either<ReponseErrorModel, String>> getNumberOfQuotationToday(
      NumberOfQuotationRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await searchListRemoteDataSource.getNumberOfQuotationToday(request);
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
  Future<Either<ReponseErrorModel, String>> getFavoriteAccess(
      FavoriteAccessModel favoriteAccessModel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await searchListRemoteDataSource
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
      var result =
          await searchListLocalDataSource.getCarObjectList(tableName, pic1Map);
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
      var result = await searchListLocalDataSource.removeCarObjectList(
          item, tableName, questionNo, index);
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
      var result = await searchListLocalDataSource.addCarObjectList(
          item, tableName, questionNo);
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
      var result = await searchListLocalDataSource
          .deleteFavoriteObjectListByPosition(tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, List<CarSearchHive>>>
      getCarListSearchFromHiveDb(String tableName) async {
    try {
      var result =
          await searchListLocalDataSource.getCarListSearchFromHiveDb(tableName);
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
      var result = await searchListLocalDataSource.getSearchHistoryObjectList(
          tableName, pic1Map);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> updateSearchHistoryObjectList(
      int index, String tableName) async {
    try {
      var result = await searchListLocalDataSource
          .updateSearchHistoryObjectList(index, tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> addSearchHistoryObjectList(
      SearchListModel element, String tableName) async {
    try {
      var result = await searchListLocalDataSource.addSearchHistoryObjectList(
          element, tableName);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
