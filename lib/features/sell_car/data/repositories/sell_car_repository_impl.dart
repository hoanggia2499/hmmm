import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/sell_car/data/datasources/sell_car_local_data_source.dart';
import 'package:mirukuru/features/sell_car/data/model/sell_car_delete_photo_request.dart';
import 'package:mirukuru/features/sell_car/data/model/sell_car_model.dart';
import 'package:mirukuru/features/sell_car/data/model/sell_car_post_question_request.dart';
import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../new_question/data/models/upload_photo_response.dart';
import '../../domain/repositories/sell_car_repository.dart';
import '../datasources/sell_car_photo_data_source.dart';
import '../datasources/sell_car_remote_data_source.dart';
import '../model/sell_car_get_list_image.dart';
import '../model/sell_car_upload_photo_request.dart';

class SellCarRepositoryImpl implements SellCarRepository {
  final SellCarRemoteDataSource sellCarRemoteDataSource;
  final SellCarLocalDataSource sellCarLocalDataSource;
  final SellCarPhotoDataSource sellCarPhotoDataSource;

  SellCarRepositoryImpl({
    required this.sellCarRemoteDataSource,
    required this.sellCarLocalDataSource,
    required this.sellCarPhotoDataSource,
  });

  /*  @override
  Future<Either<ReponseErrorModel, String>> getSellCar() async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await sellCarRemoteDataSource.getSellCar();
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
  } */

  @override
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> getLocalData() async {
    try {
      var result = await sellCarLocalDataSource.getNameBeanFromHiveDb();
      return Right(result);
    } on Exception {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, String>> postSellCar(
      SellCarModel request) async {
    var param = SellCarRequestModel.convertForm(request);

    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await sellCarRemoteDataSource.postSellCar(param);
        return Right(result);
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
  Future<Either<ReponseErrorModel, List<UploadPhotoResponseModel>?>>
      uploadPhoto(SellCarUploadPhotoRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await sellCarPhotoDataSource.uploadPhoto(request);
        return Right(result);
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

  Future<Either<ReponseErrorModel, List<String>>> getListImage(
      SellCarGetCarImagesRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await sellCarPhotoDataSource.getListImage(request);
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

  Future<Either<ReponseErrorModel, String>> deletePhoto(
      SellCarDeleteSinglePhotoRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await sellCarPhotoDataSource.deletePhoto(request);
        return Right(result);
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

  Future<Either<ReponseErrorModel, String>> deleteMultiPhoto(
      List<SellCarDeleteSinglePhotoRequestModel> request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var multipleDeleteFuture =
            request.map((e) => sellCarPhotoDataSource.deletePhoto(e));
        var resultList = await Future.wait(multipleDeleteFuture);

        var result =
            resultList.every((element) => element.isNotEmpty) ? "OK" : "";
        return Right(result);
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
