import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/message_board/data/datasources/photo_remote_data_source.dart';
import 'package:mirukuru/features/message_board/domain/repositories/photo_repository.dart';
import 'package:mirukuru/features/message_board/data/models/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/message_board/data/models/delete_photo_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/get_image_request_model.dart';

import 'package:mirukuru/features/message_board/data/models/upload_photo_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_response_model.dart';

class PhotoRepositoryImpl extends PhotoRepository {
  final PhotoRemoteDataSource photoRemoteDataSource;

  PhotoRepositoryImpl(this.photoRemoteDataSource);

  @override
  Future<Either<ReponseErrorModel, String>> deletePhoto(
      DeleteSinglePhotoRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await photoRemoteDataSource.deletePhoto(request);
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
  Future<Either<ReponseErrorModel, List<PhotoUploadResponseModel>?>>
      uploadPhoto(PhotoUploadRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await photoRemoteDataSource.uploadPhoto(request);
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
  Future<Either<ReponseErrorModel, String>> deleteMultiPhoto(
      List<DeleteSinglePhotoRequestModel> request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var multipleDeleteFuture =
            request.map((e) => photoRemoteDataSource.deletePhoto(e));
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

  @override
  Future<Either<ReponseErrorModel, List<String>?>> getMessageBoardImages(
      GetImageRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await photoRemoteDataSource.getPhotos(request);
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
  Future<Either<ReponseErrorModel, String>> deleteAllPhoto(
      DeletePhotoRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await photoRemoteDataSource.deleteAllPhoto(request);
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
