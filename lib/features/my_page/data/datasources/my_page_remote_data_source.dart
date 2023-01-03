import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_request_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_update_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_request_model.dart';

abstract class MyPageDataSource {
  Future<MyPageModel?> getMyPageInformation(MyPageRequestModel request);

  Future<String> saveMyPageInformation(MyPageUpdateModel inputModel);

  Future<List<UserCarNameModel>?> getUserCarNameList(
      List<UserCarNameRequestModel> request);
}

class MyPageDataSourceImpl implements MyPageDataSource {
  @override
  Future<MyPageModel?> getMyPageInformation(MyPageRequestModel request) async {
    String url = Common.userUrl;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum
    };

    final response = await BaseDio.instance
        .request<MyPageModel?>(url, MethodType.GET, data: params);

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
  Future<String> saveMyPageInformation(MyPageUpdateModel updateModel) async {
    String url = Common.userUrl;

    final response = await BaseDio.instance
        .request(url, MethodType.PUT, data: updateModel.toMap());

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
  Future<List<UserCarNameModel>?> getUserCarNameList(
      List<UserCarNameRequestModel> request) async {
    String url = Common.apiGetCarNamesV1;

    var requestValues = request.map((e) => (e).toJson()).toList();
    final params = Map<String, List<String>>();
    params.putIfAbsent('carNameRequest', () => requestValues);

    final response = await BaseDio.instance
        .request<List<UserCarNameModel>>(url, MethodType.GET, data: params);

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
