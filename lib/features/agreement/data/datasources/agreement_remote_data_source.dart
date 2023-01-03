import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import '../../../../core/error/exceptions.dart';

abstract class AgreementDataSource {
  Future<String?> getAgreement();

  Future<String?> sendMailNewUser(String memberNum, int userNum);
}

class AgreementDataSourceImpl implements AgreementDataSource {
  AgreementDataSourceImpl();

  @override
  Future<String?> getAgreement() async {
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

  Future<String?> sendMailNewUser(String memberNum, int userNum) async {
    String url = Common.apiGetMailNewUser;

    var params = <String, dynamic>{
      'memberNum': memberNum,
      'userNum': userNum,
    };

    final response =
        await BaseDio.instance.request(url, MethodType.POST, data: params);

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
