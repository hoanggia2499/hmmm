import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

import '../../data/models/number_of_quotation_request.dart';

class GetNumberOfQuotationToday
    implements UseCaseExtend<String, NumberOfQuotationRequestModel> {
  final SearchListRepository repository;

  GetNumberOfQuotationToday(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      NumberOfQuotationRequestModel params) async {
    return await repository.getNumberOfQuotationToday(params);
  }
}
