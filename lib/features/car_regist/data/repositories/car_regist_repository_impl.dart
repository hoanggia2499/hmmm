import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/car_regist/data/datasources/car_regist_remote_data_source.dart';
import 'package:mirukuru/features/car_regist/data/model/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/car_regist/data/model/delete_photo_request_model.dart';
import 'package:mirukuru/features/car_regist/data/model/post_own_car_request.dart';
import 'package:mirukuru/features/car_regist/data/model/upload_photo_request_model.dart';
import 'package:mirukuru/features/car_regist/data/model/upload_photo_response_model.dart';
import 'package:mirukuru/features/car_regist/domain/repositories/car_regist_repository.dart';
import '../../../../core/error/error_model.dart';
import '../datasources/car_regist_local_data_source.dart';
import '../datasources/car_regist_photo_remote_data_source.dart';
import '../model/local_data_model.dart';
import '../model/delete_own_car_request.dart';
import '../model/get_car_images_request.dart';
import '../model/post_own_car_response.dart';

class CarRegisRepositoryImpl implements CarRegistRepository {
  final CarRegisDataSource remoteDataSource;
  final CarRegisLocalDataSource localDataSource;
  final CarRegisPhotoRemoteDataSource carRegisPhotoRemoteDataSource;

  CarRegisRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.carRegisPhotoRemoteDataSource});

  Future<Either<ReponseErrorModel, List<String>>> getListImage(
      GetCarImagesRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await carRegisPhotoRemoteDataSource.getListImage(request);
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
      DeleteSinglePhotoRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await carRegisPhotoRemoteDataSource.deletePhoto(request);
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

  Future<Either<ReponseErrorModel, List<PhotoUploadResponseModel>?>>
      uploadPhoto(PhotoUploadRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await carRegisPhotoRemoteDataSource.uploadPhoto(request);
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
      List<DeleteSinglePhotoRequestModel> request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var multipleDeleteFuture =
            request.map((e) => carRegisPhotoRemoteDataSource.deletePhoto(e));
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

  Future<Either<ReponseErrorModel, String>> deleteAllPhoto(
      DeletePhotoRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await carRegisPhotoRemoteDataSource.deleteAllPhoto(request);
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

  Future<Either<ReponseErrorModel, String>> deleteOwnCar(
      DeleteOwnCarRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.deleteOwnCar(request);
        if (result != null && result.isNotEmpty) {
          await localDataSource.deleteUserCarFromListHiveDb(
              Constants.USER_CAR_TABLE, (request.userCarNum ?? 0).toString());
        }
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
  Future<Either<ReponseErrorModel, PostOwnCarResponse>> postOwnCar(
      PostOwnCarRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.postOwnCar(request);
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
  Future<Either<ReponseErrorModel, LocalModel>> getLocalData() async {
    try {
      var listRIKUJI = await localDataSource.getListRIKUJI();
      var listNameBeanHive = await localDataSource.getNameBeanFromHiveDb();

      var result = LocalModel(listRIKUJI, listNameBeanHive);

      return Right(result);
    } on Exception {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
