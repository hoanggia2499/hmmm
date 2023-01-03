import 'package:mirukuru/features/inform_list/data/models/inform_list_request.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_response.dart';

import '../../../../core/config/common.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_base.dart';
import '../../../../core/network/task_type.dart';

abstract class InformListRemoteDataSource {
  Future<List<InformListResponseModel>?> getFormList(
      InformListRequestModel request);
}

class InformListRemoteDataSourceImpl implements InformListRemoteDataSource {
  @override
  Future<List<InformListResponseModel>?> getFormList(
      InformListRequestModel request) async {
    String url = Common.listInformsUrl;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum
    };

    final response = await BaseDio.instance
        .request<List<InformListResponseModel>>(url, MethodType.GET,
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
