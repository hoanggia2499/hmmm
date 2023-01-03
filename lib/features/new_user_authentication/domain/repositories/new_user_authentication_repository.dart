import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';

abstract class NewUserAuthenticationRepository {
  Future<Either<ReponseErrorModel, String>> requestNewUserAuthentication(
      int id, String tel, String authCode);
}
