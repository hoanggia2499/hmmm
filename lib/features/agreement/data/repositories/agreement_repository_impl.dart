import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/agreement_repository.dart';
import '../datasources/agreement_remote_data_source.dart';

class AgreementRepositoryImpl implements AgreementRepository {
  final AgreementDataSource agreementDataSource;

  AgreementRepositoryImpl({
    required this.agreementDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, String>> getAgreement() async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await agreementDataSource.getAgreement();
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

  Future<Either<ReponseErrorModel, String>> sendMailNewUser(
      String memberNum, int userNum) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await agreementDataSource.sendMailNewUser(memberNum, userNum);
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
