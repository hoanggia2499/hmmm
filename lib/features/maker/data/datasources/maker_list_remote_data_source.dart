import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class MakerListDataSource {
  Future<List<ItemMakerModel>?> getMakerList();
}

class MakerListDataSourceImpl extends MakerListDataSource {
  MakerListDataSourceImpl();
  @override
  Future<List<ItemMakerModel>?> getMakerList() async {
    String url = Common.apiGetMaker;

    final response = await BaseDio.instance
        .request<List<ItemMakerModel>>(url, MethodType.GET);

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
