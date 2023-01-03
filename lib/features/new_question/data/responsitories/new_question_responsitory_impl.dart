import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_request_model.dart';
import 'package:mirukuru/features/new_question/data/datasources/new_question_local_data_source.dart';
import 'package:mirukuru/features/new_question/data/datasources/new_question_remote_data_source.dart';
import 'package:mirukuru/features/new_question/data/models/delete_photo_request.dart';
import 'package:mirukuru/features/new_question/data/models/new_question_request.dart';
import 'package:mirukuru/features/new_question/data/models/upload_photo_request.dart';
import 'package:mirukuru/features/new_question/data/models/new_question_model.dart';
import 'package:mirukuru/features/new_question/domain/responsitories/new_question_reponsitory.dart';

import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/util/connection_util.dart';
import '../../../../core/util/error_code.dart';
import '../models/upload_photo_response.dart';
import '../models/user_info_request_model.dart';
import '../models/user_info_response_model.dart';

class NewQuestionRepositoryImpl implements NewQuestionRepository {
  final NewQuestionRemoteDataSource remoteDataSource;
  final NewQuestionLocalDataSource localDataSource;

  NewQuestionRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<ReponseErrorModel, UserInfoResponseModel?>> getUserInfo(
      UserInfoRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.getUserInfo(request);

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
  Future<Either<ReponseErrorModel, List<UserCarNameModel>?>> getCarList(
      List<UserCarNameRequestModel> request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.getCarList(request);
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
  Future<Either<ReponseErrorModel, String>> postNewQuestion(
      NewQuestionModel request) async {
    var param = NewQuestionRequestModel.convertForm(request);

    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.postNewQuestion(param);
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
  Future<Either<ReponseErrorModel, String>> deletePhotoAfterPosted(
      NewQuestionModel request) async {
    var param = DeletePhotoRequestModel.convertForm(request);

    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.deletePhotoAfterPosted(param);
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
      uploadPhoto(NewQuestionModel request) async {
    var param = UploadPhotoRequestModel.convertForm(request);

    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.uploadPhoto(param);
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
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> getLocalData() async {
    try {
      var listNameBeanHive = await localDataSource.getNameBeanFromHiveDb();

      var result = listNameBeanHive;

      return Right(result);
    } on Exception {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
