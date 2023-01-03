import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/features/new_user_authentication/domain/repositories/new_user_authentication_repository.dart';
import '../../../../core/error/error_model.dart';

class NewUserAuthentication implements UseCaseExtend<String, Params> {
  final NewUserAuthenticationRepository repository;

  NewUserAuthentication(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(Params params) async {
    return await repository.requestNewUserAuthentication(
        params.id, params.tel, params.authCode);
  }
}

class Params extends Equatable {
  final int id;
  final String tel;
  final String authCode;

  Params({required this.id, required this.tel, required this.authCode});

  @override
  List<Object> get props => [id, tel, authCode];
}
