import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/network/paginated_data_request_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/quotation_list_repository.dart';
import '../datasources/quotation_list_remote_data_source.dart';

class QuotationListImpl implements QuotationListRepository {
  final QuotationListDataSource quotationListDataSource;

  QuotationListImpl({
    required this.quotationListDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>>
      getRequestQuotation(PaginatedDataRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await quotationListDataSource.getRequestQuotation(request);
        return Right(result!);
      } on ServerException catch (error) {
        return Left(
            ReponseErrorModel(msgCode: error.code, msgContent: error.content));
      } on Exception {
        return Left(ReponseErrorModel(
            msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
      }
    } else {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
    }
  }
}
