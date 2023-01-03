import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/user_registration_repository.dart';
import '../datasources/user_registration_remote_data_source.dart';
import '../models/personal_register_model.dart';
import '../models/user_registration_model.dart';

class UserRegistrationRepositoryImpl implements UserRegistrationRepository {
  final UserRegistrationDataSource userRegistrationDataSource;

  UserRegistrationRepositoryImpl({
    required this.userRegistrationDataSource,
  });

  Future<Either<ReponseErrorModel, UserRegistrationModel>> requestPretreatment(
      int id, String tel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await userRegistrationDataSource.requestPretreatment(id, tel);
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

  Future<Either<ReponseErrorModel, String>> requestRegister(
      int id, String tel, String userName, String userNameKana) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await userRegistrationDataSource.requestRegister(
            id, tel, userName, userNameKana);
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

  Future<Either<ReponseErrorModel, PersonalRegisterModel>> personalRegister(
      int id, String tel, String userName, String userNameKana) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await userRegistrationDataSource.personalRegister(
            id, tel, userName, userNameKana);
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
