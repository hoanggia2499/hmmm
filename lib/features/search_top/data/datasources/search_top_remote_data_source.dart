import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import '../../../../core/error/exceptions.dart';
import '../models/company_get_model.dart';
import '../models/name_model.dart';

abstract class SearchTopRemoteDataSource {
  Future<NameModel?> getName();

  Future<int?> getNumberOfUnread(String memberNum, int userNum);

  Future<CompanyGetModel?> companyGet(String memberNum);
}

class TopRemoteDataSourceImpl implements SearchTopRemoteDataSource {
  TopRemoteDataSourceImpl();

  @override
  Future<NameModel?> getName() async {
    String url = Common.apiGetNames;

    LoginModel loginModel = await HelperFunction.instance.getLoginModel();

    var params = <String, dynamic>{
      'memberNum': loginModel.memberNum,
      'userNum': loginModel.userNum,
    };

    final response = await BaseDio.instance
        .request<NameModel>(url, MethodType.GET, data: params);

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
  Future<int?> getNumberOfUnread(String memberNum, int userNum) async {
    String url = Common.apiGetNumberOfUnread;

    var params = <String, dynamic>{
      'memberNum': memberNum,
      'userNum': userNum,
    };

    final response =
        await BaseDio.instance.request<int>(url, MethodType.GET, data: params);

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

  Future<CompanyGetModel?> companyGet(String memberNum) async {
    String url = Common.companyUrl;

    var params = <String, dynamic>{
      'memberNum': memberNum,
    };

    final response = await BaseDio.instance
        .request<CompanyGetModel>(url, MethodType.GET, data: params);

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
