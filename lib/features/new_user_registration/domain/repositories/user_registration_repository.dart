import 'package:dartz/dartz.dart';
import '../../../../core/error/error_model.dart';
import '../../data/models/personal_register_model.dart';
import '../../data/models/user_registration_model.dart';

abstract class UserRegistrationRepository {
  Future<Either<ReponseErrorModel, UserRegistrationModel>> requestPretreatment(
      int id, String tel);

  Future<Either<ReponseErrorModel, String>> requestRegister(
      int id, String tel, String userName, String userNameKana);

  Future<Either<ReponseErrorModel, PersonalRegisterModel>> personalRegister(
      int id, String tel, String userName, String userNameKana);
}
