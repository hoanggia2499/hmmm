import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../data/models/user_registration_model.dart';
import '../repositories/user_registration_repository.dart';

class NewUserRegistration
    implements UseCaseExtend<UserRegistrationModel, Params> {
  final UserRegistrationRepository repository;

  NewUserRegistration(this.repository);

  @override
  Future<Either<ReponseErrorModel, UserRegistrationModel>> call(
      Params params) async {
    return await repository.requestPretreatment(params.id, params.tel);
  }
}

class Params extends Equatable {
  final int id;
  final String tel;

  Params({required this.id, required this.tel});

  @override
  List<Object> get props => [id, tel];
}
