import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import '../../../../core/error/exceptions.dart';
import '../model/sell_car_post_question_request.dart';

abstract class SellCarRemoteDataSource {
  Future<String?> getSellCar();

  Future<String> postSellCar(SellCarRequestModel request);
}

class SellCarRemoteDataSourceImpl implements SellCarRemoteDataSource {
  SellCarRemoteDataSourceImpl();

  @override
  Future<String?> getSellCar() async {
    // HARD CODE
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
  Future<String> postSellCar(SellCarRequestModel request) async {
    String url = Common.questionUrl;

    var params = <String, dynamic>{
      "memberNum": request.memberNum,
      "userNum": request.userNum,
      "exhNum": request.exhNum,
      "userCarNum": request.userCarNum,
      "makerCode": request.makerCode,
      "makerName": request.makerName,
      "carName": request.carName,
      "id": request.id,
      "question": request.question,
      "questionKbn": request.questionKbn,
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
