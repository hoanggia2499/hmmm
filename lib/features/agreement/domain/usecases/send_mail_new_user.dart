import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/agreement_repository.dart';

class SendMailNewUser implements UseCaseExtend<String, ParamRequests> {
  final AgreementRepository repository;

  SendMailNewUser(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(ParamRequests params) async {
    return await repository.sendMailNewUser(params.memberNum, params.userNum);
  }
}

class ParamRequests extends Equatable {
  final String memberNum;
  final int userNum;

  ParamRequests({required this.memberNum, required this.userNum});

  @override
  List<Object> get props => [memberNum, userNum];
}
