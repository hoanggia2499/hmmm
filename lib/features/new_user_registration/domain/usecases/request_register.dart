import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/user_registration_repository.dart';

class RequestRegister implements UseCaseExtend<String, ParamRequests> {
  final UserRegistrationRepository repository;

  RequestRegister(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(ParamRequests params) async {
    return await repository.requestRegister(
        params.id, params.tel, params.userName!, params.userNameKana!);
  }
}

class ParamRequests extends Equatable {
  final int id;
  final String tel;
  final String? userName;
  final String? userNameKana;

  ParamRequests(
      {required this.id, required this.tel, this.userName, this.userNameKana});

  @override
  List<Object> get props => [id, tel, userName ?? '', userNameKana ?? ''];
}
