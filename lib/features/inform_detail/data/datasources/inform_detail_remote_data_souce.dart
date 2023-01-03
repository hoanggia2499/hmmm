import 'package:mirukuru/features/inform_detail/data/models/carSP_request.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_response.dart';

import '../../../../core/config/common.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_base.dart';
import '../../../../core/network/task_type.dart';
import '../models/inform_detail_request.dart';

abstract class InformDetailRemoteDataSource {
  Future<String?> getFormList(InformDetailRequestModel request);
  Future<CarSPResponseModel?> getCarSP(CarSPRequestModel request);
}

class InformDetailRemoteDataSourceImpl implements InformDetailRemoteDataSource {
  @override
  Future<String?> getFormList(InformDetailRequestModel request) async {
    String url = Common.informUrl;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum,
      'sendNum': request.sendNum
    };

    final response = await BaseDio.instance
        .request<String>(url, MethodType.PUT, data: params);

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
  Future<CarSPResponseModel?> getCarSP(CarSPRequestModel request) async {
    String url = Common.apiGetCar;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'corner': request.corner,
      'aACount': request.aACount,
      'exhNum': request.exhNum,
    };

    final response = await BaseDio.instance
        .request<CarSPResponseModel>(url, MethodType.GET, data: params);

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
