import 'package:dartz/dartz.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/agreement_repository.dart';

class GetAgreement implements UseCaseExtend<String, NoParamsExt> {
  final AgreementRepository repository;

  GetAgreement(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(NoParamsExt params) async {
    return await repository.getAgreement();
  }
}
