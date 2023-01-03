import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/network/paginated_data_request_model.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import '../../../../core/error/exceptions.dart';

abstract class QuotationListDataSource {
  Future<PaginatedDataModel<QuestionBean>?> getRequestQuotation(
      PaginatedDataRequestModel request);
}

class QuotationListDataSourceImpl implements QuotationListDataSource {
  QuotationListDataSourceImpl();

  @override
  Future<PaginatedDataModel<QuestionBean>?> getRequestQuotation(
      PaginatedDataRequestModel request) async {
    String url = Common.apiGetEstimateRequests;

    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '';

    var params = <String, dynamic>{
      'memberNum': memberNum,
      'userNum': userNum,
    };
    params.addAll(request.toMap());

    final response = await BaseDio.instance
        .request<PaginatedDataModel<QuestionBean>?>(url, MethodType.GET,
            data: params);

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data;
      default:
        throw ServerException(
          response.messageCode,
          response.messageContent,
        );
    }
  }
}
