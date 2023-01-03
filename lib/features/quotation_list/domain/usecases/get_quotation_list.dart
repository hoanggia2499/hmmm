import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/network/paginated_data_request_model.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/quotation_list_repository.dart';

class GetQuotationList
    implements
        UseCaseExtend<PaginatedDataModel<QuestionBean>,
            PaginatedDataRequestModel> {
  final QuotationListRepository repository;

  GetQuotationList(this.repository);

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>> call(
      PaginatedDataRequestModel request) async {
    return await repository.getRequestQuotation(request);
  }
}
