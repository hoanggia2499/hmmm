import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import '../../../../core/error/error_model.dart';
import '../repositories/login_repository.dart';

class CheckUserAvailable implements UseCaseExtend<String, ParamCheckUser> {
  final LoginRepository repository;

  CheckUserAvailable(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(ParamCheckUser params) async {
    return await repository.checkAppUserAvailable(
        params.memberNum, params.userNum);
  }
}

class ParamCheckUser extends Equatable {
  final String memberNum;
  final int userNum;

  ParamCheckUser({required this.memberNum, required this.userNum});

  @override
  List<Object> get props => [memberNum, userNum];
}
