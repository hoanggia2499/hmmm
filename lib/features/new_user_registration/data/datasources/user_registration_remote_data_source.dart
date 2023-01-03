import 'package:mirukuru/core/network/dio_base.dart';
import '../../../../core/config/common.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/task_type.dart';
import '../models/personal_register_model.dart';
import '../models/user_registration_model.dart';

abstract class UserRegistrationDataSource {
  Future<UserRegistrationModel?> requestPretreatment(int id, String tel);

  Future<String?> requestRegister(
      int id, String tel, String userName, String userNameKana);

  Future<PersonalRegisterModel?> personalRegister(
      int id, String tel, String userName, String userNameKana);
}

class UserRegistrationDataSourceImpl implements UserRegistrationDataSource {
  BaseDio? client;
  UserRegistrationDataSourceImpl({this.client});

  @override
  Future<UserRegistrationModel?> requestPretreatment(int id, String tel) async {
    String url = Common.apiPostPretreatment;

    var params = <String, dynamic>{
      'id': id,
      'tel': tel,
    };

    final response = await BaseDio.instance
        .request<UserRegistrationModel>(url, MethodType.POST, data: params);

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

  Future<String?> requestRegister(
      int id, String tel, String userName, String userNameKana) async {
    String url = Common.userUrl;

    var params = <String, dynamic>{
      'id': id,
      'tel': tel,
      'userName': userName,
      'userNameKana': userNameKana,
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

  Future<PersonalRegisterModel?> personalRegister(
      int id, String tel, String userName, String userNameKana) async {
    String url = Common.apiPostPersonal;

    var params = <String, dynamic>{
      'id': id,
      'tel': tel,
      'userName': userName,
      'userNameKana': userNameKana,
    };

    final response = await BaseDio.instance
        .request<PersonalRegisterModel>(url, MethodType.POST, data: params);

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
