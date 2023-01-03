import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/search_detail/data/datasources/search_detail_local_data_source.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import '../../../../core/error/error_model.dart';
import '../../domain/repositories/search_detail_repository.dart';
import '../datasources/search_detail_remote_data_source.dart';

class SearchDetailRepositoryImpl implements SearchDetailRepository {
  final SearchDetailDataSource seachDetailDataSource;
  final SearchDetailLocalDataSource searchDetailLocalDataSource;
  SearchDetailRepositoryImpl(
      {required this.seachDetailDataSource,
      required this.searchDetailLocalDataSource});

  @override
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> getSeachDetail(
      SearchCarInputModel searchCarInputModel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await seachDetailDataSource.getSeachDetail(searchCarInputModel);
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

  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getFavoriteList(
      String tableName, Map<String, String> pic1Map) async {
    try {
      var result =
          await searchDetailLocalDataSource.getFavoriteList(tableName, pic1Map);
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
      var result = await searchDetailLocalDataSource
          .deleteFavoriteObjectListByPosition(tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> addFavorite(
      ItemSearchModel item, String tableName, String questionNo) async {
    try {
      var result = await searchDetailLocalDataSource.addFavorite(
          item, tableName, questionNo);
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
        var result =
            await seachDetailDataSource.getFavoriteAccess(favoriteAccessModel);
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
}
