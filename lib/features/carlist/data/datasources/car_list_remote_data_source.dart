import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/carlist/domain/usecases/get_carList.dart';

import '../../../../core/error/exceptions.dart';

abstract class CarListRemoteDataSource {
  Future<List<CarModel>?> getCarList(ParamCarListRequests param);
}

class CarListRemoteDataSourceImpl implements CarListRemoteDataSource {
  CarListRemoteDataSourceImpl();

  @override
  Future<List<CarModel>?> getCarList(ParamCarListRequests param) async {
    String url = '';
    if (param.caller == "CarRegistActivity") {
      url = Common.apiGetCarsByMakerCode;
    } else {
      // param.caller =  "SearchTopActivity" or "MakerListActivity" or...
      url = Common.apiGetListCars;
    }

    var params = <String, dynamic>{
      'makerCode': param.makerCode,
    };

    final response = await BaseDio.instance
        .request<List<CarModel>>(url, MethodType.GET, data: params);

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
