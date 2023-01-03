import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import '../../../../core/config/common.dart';
import 'dart:io';

abstract class LoginDataSource {
  Future<LoginModel?> appLogin(int id, String pass, String apVersion);

  Future<String?> checkAppUserAvailable(String memberNum, int userNum);
  Future<String?> postPushId(String memberNum, int userNum,
      String androidPushId, String iosPushId, int deviceType);
}

class LoginDataSourceImpl implements LoginDataSource {
  BaseDio? client;
  LoginDataSourceImpl({this.client});
  @override
  Future<LoginModel?> appLogin(int id, String pass, String apVersion) async {
    String url = Common.apiLogin;
    var params = <String, dynamic>{
      'id': id,
      'pass': pass,
      'appVersion': apVersion
    };
    if (Platform.isAndroid) {
      params.addAll(<String, dynamic>{'deviceType': 1});
    } else if (Platform.isIOS) {
      params.addAll(<String, dynamic>{'deviceType': 2});
    }

    final response = await BaseDio.instance
        .request<LoginModel>(url, MethodType.GET, data: params);

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data!;
      default:
        throw ServerException(
          response.messageCode,
          response.messageContent,
        );
    }
  }

  @override
  Future<String?> checkAppUserAvailable(String memberNum, int userNum) async {
    String url = Common.apiGetUserTerm;

    var params = <String, dynamic>{
      'memberNum': memberNum,
      'userNum': userNum,
    };

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

  @override
  Future<String?> postPushId(String memberNum, int userNum,
      String androidPushId, String iosPushId, int deviceType) async {
    String url = Common.apiPostPushId;

    var params = <String, dynamic>{
      'memberNum': memberNum,
      'userNum': userNum,
      'androidPushId': androidPushId,
      'iOSPushId': iosPushId,
      'deviceType': deviceType
    };

    final response = await BaseDio.instance
        .request<String>(url, MethodType.POST, data: params);

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
