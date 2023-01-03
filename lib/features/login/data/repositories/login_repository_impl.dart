import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import '../../../../core/error/error_model.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl({
    required this.loginDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, LoginModel>> login(
      id, String pass, String apVersion) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await loginDataSource.appLogin(id, pass, apVersion);
        return Right(result!);
      } on SocketException {
        return Left(ReponseErrorModel(
            msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
      } on ServerException catch (error) {
        return Left(
            ReponseErrorModel(msgCode: error.code, msgContent: error.content));
      } on Exception {
        return Left(ReponseErrorModel(
            msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
      }
    } else {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, String>> checkAppUserAvailable(
      String memberNum, int userNum) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await loginDataSource.checkAppUserAvailable(memberNum, userNum);
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

  Future<Either<ReponseErrorModel, String>> postPushId(
      String memberNum,
      int userNum,
      String androidPushId,
      String iosPushId,
      int deviceType) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await loginDataSource.postPushId(
            memberNum, userNum, androidPushId, iosPushId, deviceType);
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
