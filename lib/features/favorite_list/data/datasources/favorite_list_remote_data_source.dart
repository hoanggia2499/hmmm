import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';

import '../../../search_list/data/models/item_car_pic1_model.dart';

abstract class FavoriteListDataSource {
  Future<List<ItemCarPic1Model>?> getCarPic1();
  Future<String?> getFavoriteList();
}

class FavoriteListDataSourceImpl implements FavoriteListDataSource {
  FavoriteListDataSourceImpl();

  @override
  Future<String?> getFavoriteList() async {
    String url = Common.apiGetAgreement;

    final response =
        await BaseDio.instance.request<String>(url, MethodType.GET);

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(response.messageCode, response.messageContent);
        }
        return response.data;
      default:
        throw ServerException(response.messageCode, response.messageContent);
    }
  }

  @override
  Future<List<ItemCarPic1Model>?> getCarPic1() async {
    String url = Common.apiGetCarPic1;

    final response = await BaseDio.instance
        .request<List<ItemCarPic1Model>>(url, MethodType.GET);

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(response.messageCode, response.messageContent);
        }
        return response.data;
      default:
        throw ServerException(response.messageCode, response.messageContent);
    }
  }
}
