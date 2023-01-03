import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../data/models/personal_register_model.dart';
import '../repositories/user_registration_repository.dart';

class PersonalRegister
    implements UseCaseExtend<PersonalRegisterModel, ParamPersonal> {
  final UserRegistrationRepository repository;

  PersonalRegister(this.repository);

  @override
  Future<Either<ReponseErrorModel, PersonalRegisterModel>> call(
      ParamPersonal params) async {
    return await repository.personalRegister(
        params.id, params.tel, params.userName!, params.userNameKana!);
  }
}

class ParamPersonal extends Equatable {
  final int id;
  final String tel;
  final String? userName;
  final String? userNameKana;

  ParamPersonal(
      {required this.id, required this.tel, this.userName, this.userNameKana});

  @override
  List<Object> get props => [id, tel, userName ?? '', userNameKana ?? ''];
}
