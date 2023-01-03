import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/new_user_authentication/data/datasources/new_user_authentication_remote_data_source.dart';
import 'package:mirukuru/features/new_user_authentication/domain/repositories/new_user_authentication_repository.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';

class NewUserAuthenticationRepositoryImpl
    implements NewUserAuthenticationRepository {
  final NewUserAuthenticationDataSource aboutDataSource;

  NewUserAuthenticationRepositoryImpl({required this.aboutDataSource});

  @override
  Future<Either<ReponseErrorModel, String>> requestNewUserAuthentication(
      int id, String tel, String authCode) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await aboutDataSource.requestNewUserAuthentication(
            id, tel, authCode);
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
