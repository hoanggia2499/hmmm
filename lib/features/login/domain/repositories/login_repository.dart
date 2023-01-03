import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';

import '../../../../core/error/error_model.dart';

abstract class LoginRepository {
  Future<Either<ReponseErrorModel, LoginModel>> login(
      int id, String pass, String apVersion);

  Future<Either<ReponseErrorModel, String>> checkAppUserAvailable(
      String memberNum, int userNum);
  Future<Either<ReponseErrorModel, String>> postPushId(String memberNum,
      int userNum, String androidPushId, String iosPushId, int deviceType);
}
