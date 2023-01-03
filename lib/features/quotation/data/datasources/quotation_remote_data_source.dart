import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/quotation/data/models/inquiry_request_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../search_detail/data/models/search_car_input_model.dart';
import '../../../search_detail/data/models/search_car_model.dart';

abstract class QuotationDataSource {
  Future<List<SearchCarModel>?> getSeachDetail(
      SearchCarInputModel searchCarInputModel);

  Future<String?> getQuotation();

  Future<String?> makeAnInquiry(InquiryRequestModel quotationRequest);
}

class QuotationDataSourceImpl implements QuotationDataSource {
  QuotationDataSourceImpl();

  @override
  Future<String?> getQuotation() async {
    String url = Common.apiGetAgreement;

    final response =
        await BaseDio.instance.request<String>(url, MethodType.GET);

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

  @override
  Future<String?> makeAnInquiry(InquiryRequestModel quotationRequest) async {
    String url = Common.questionUrl;

    final response = await BaseDio.instance
        .request<String>(url, MethodType.POST, data: quotationRequest.toMap());

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

  @override
  Future<List<SearchCarModel>?> getSeachDetail(
      SearchCarInputModel searchCarInputModel) async {
    String url = Common.apiGetSearchCar;

    var params = <String, dynamic>{
      'memberNum': searchCarInputModel.memberNum,
      'userNum': searchCarInputModel.userNum,
      'corner': searchCarInputModel.corner,
      'aACount': searchCarInputModel.aACount,
      'exhNum': searchCarInputModel.exhNum,
      'carNo': searchCarInputModel.carNo,
      'makerCode': searchCarInputModel.makerCode
    };

    final response = await BaseDio.instance
        .request<List<SearchCarModel>>(url, MethodType.GET, data: params);

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
