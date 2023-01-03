import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/features/search_top/domain/repositories/search_top_repository.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../../search_top/data/models/company_get_model.dart';

class CompanyGet implements UseCaseExtend<CompanyGetModel, ParamCompanyGet> {
  final SearchTopRepository repository;

  CompanyGet(this.repository);

  @override
  Future<Either<ReponseErrorModel, CompanyGetModel>> call(
      ParamCompanyGet params) async {
    return await repository.companyGet(params.memberNum);
  }
}

class ParamCompanyGet extends Equatable {
  final String memberNum;

  ParamCompanyGet({required this.memberNum});

  @override
  List<Object> get props => [memberNum];
}
