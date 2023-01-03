import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';

import '../../../../core/error/exceptions.dart';

abstract class NewUserAuthenticationDataSource {
  Future<String?> requestNewUserAuthentication(
      int id, String tel, String authCode);
}

class NewUserAuthenticationDataSourceImpl
    implements NewUserAuthenticationDataSource {
  NewUserAuthenticationDataSourceImpl();

  @override
  Future<String?> requestNewUserAuthentication(
      int id, String tel, String authCode) async {
    String url = Common.apiGetUserAuthentication;

    var params = <String, dynamic>{'id': id, 'tel': tel, 'authCode': authCode};

    final response = await BaseDio.instance
        .request<String>(url, MethodType.GET, data: params);

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
