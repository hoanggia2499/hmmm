import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/network/paginated_data_request_model.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import '../../../../core/error/error_model.dart';

abstract class QuotationListRepository {
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>>
      getRequestQuotation(PaginatedDataRequestModel request);
}
