import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/features/car_regist/data/model/post_own_car_request.dart';
import '../model/delete_own_car_request.dart';
import '../model/post_own_car_response.dart';

abstract class CarRegisDataSource {
  Future<String?> deleteOwnCar(DeleteOwnCarRequestModel request);
  Future<PostOwnCarResponse?> postOwnCar(PostOwnCarRequestModel request);
}

class CarRegisRepositoryDataSourceImpl implements CarRegisDataSource {
  CarRegisRepositoryDataSourceImpl();

  @override
  Future<String?> deleteOwnCar(DeleteOwnCarRequestModel request) async {
    String url = Common.ownCarUrl;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum,
      'userCarNum': request.userCarNum,
    };
    var realUrl = HelperFunction.instance.formatRealUrl(url, params);
    final response = await BaseDio.instance
        .request<String>(realUrl, MethodType.DELETE, data: params);

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
  Future<PostOwnCarResponse?> postOwnCar(PostOwnCarRequestModel request) async {
    String url = Common.ownCarUrl;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum,
      'userCarNum': request.userCarNum,
      'plateNo1': request.plateNo1,
      'plateNo2': request.plateNo2,
      'plateNo3': request.plateNo3,
      'plateNo4': request.plateNo4,
      'makerCode': request.makerCode,
      'carCode': request.carCode,
      'carGrade': request.carGrade,
      'carModel': request.carModel,
      'platformNum': request.platformNum,
      'bodyColor': request.bodyColor,
      'mileage': request.mileage,
      'inspectionDate': request.inspectionDate != null
          ? DateTime.parse(request.inspectionDate!).toIso8601String()
          : null,
      'inspectionFlag': request.inspectionFlag,
      'sellTime': request.sellTime,
      'buyTime': request.buyTime,
      'nhokenKbn': request.nHokenKbn,
      'nhokenInc': request.nHokenInc,
      'nhokenEndDay': request.nHokenEndDay,
    };

    final response = await BaseDio.instance
        .request<PostOwnCarResponse>(url, MethodType.POST, data: params);

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
