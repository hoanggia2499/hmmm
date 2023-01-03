import 'package:dartz/dartz.dart';
import '../../../../core/error/error_model.dart';

abstract class AgreementRepository {
  Future<Either<ReponseErrorModel, String>> getAgreement();

  Future<Either<ReponseErrorModel, String>> sendMailNewUser(
      String memberNum, int userNum);
}
