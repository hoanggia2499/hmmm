import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/favorite_detail/data/datasources/favorite_detail_local_data_source.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import '../../../../core/error/error_model.dart';
import '../../domain/repositories/favorite_detail_repository.dart';
import '../datasources/favorite_detail_remote_data_source.dart';

class FavoriteDetailRepositoryImpl implements FavoriteDetailRepository {
  final FavoriteDetailDataSource favoriteDetailDataSource;
  final FavoriteDetailLocalDataSource favoriteDetailLocalDataSource;
  FavoriteDetailRepositoryImpl(
      {required this.favoriteDetailDataSource,
      required this.favoriteDetailLocalDataSource});

  @override
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> getFavoriteDetail(
      SearchCarInputModel searchCarInputModel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await favoriteDetailDataSource.getSeachDetail(searchCarInputModel);
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
      var result = await favoriteDetailLocalDataSource.getCarObjectList(
          tableName, pic1Map);
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
      var result = await favoriteDetailLocalDataSource.addCarObjectList(
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
      var result = await favoriteDetailLocalDataSource
          .deleteFavoriteObjectListByPosition(tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
