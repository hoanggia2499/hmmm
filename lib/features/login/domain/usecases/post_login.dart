import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../data/models/login_model.dart';
import '../repositories/login_repository.dart';

class PostLogin implements UseCaseExtend<LoginModel, ParamLogin> {
  final LoginRepository repository;

  PostLogin(this.repository);

  @override
  Future<Either<ReponseErrorModel, LoginModel>> call(ParamLogin params) async {
    return await repository.login(params.id, params.pass, params.apVersion);
  }
}

class ParamLogin extends Equatable {
  final int id;
  final String pass;
  final String apVersion;

  ParamLogin({required this.id, required this.pass, required this.apVersion});

  @override
  List<Object> get props => [id, pass, apVersion];
}
