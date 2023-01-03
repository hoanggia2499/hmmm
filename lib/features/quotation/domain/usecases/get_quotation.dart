import 'package:dartz/dartz.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/quotation_repository.dart';

class GetQuotation implements UseCaseExtend<String, NoParamsExt> {
  final QuotationRepository repository;

  GetQuotation(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(NoParamsExt params) async {
    return await repository.getQuotation();
  }
}
