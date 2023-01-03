import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/store_information/data/models/store_information_model.dart';

abstract class StoreRemoteDataSource {
  Future<StoreInformationModel?> getStoreInformation(String memberNum);
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  @override
  Future<StoreInformationModel?> getStoreInformation(String memberNum) async {
    String url = Common.companyUrl;

    var params = <String, dynamic>{
      'memberNum': memberNum,
    };

    final response = await BaseDio.instance
        .request<StoreInformationModel?>(url, MethodType.GET, data: params);

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
