import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class BodyListRemoteDataSource {
  Future<List<BodyModel>?> getBodyList(int id);
}

class BodyListRemoteDataSourceImpl implements BodyListRemoteDataSource {
  BodyListRemoteDataSourceImpl();

  @override
  Future<List<BodyModel>?> getBodyList(int id) async {
    String url = Common.apiGetBodyType;

    var params = <String, dynamic>{
      'Id': id,
    };

    final response = await BaseDio.instance
        .request<List<BodyModel>>(url, MethodType.GET, data: params);

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
