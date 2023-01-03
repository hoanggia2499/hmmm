import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';

abstract class FavoriteDetailDataSource {
  Future<List<SearchCarModel>?> getSeachDetail(
      SearchCarInputModel searchCarInputModel);
}

class FavoriteDetailDataSourceImpl implements FavoriteDetailDataSource {
  FavoriteDetailDataSourceImpl();

  @override
  Future<List<SearchCarModel>?> getSeachDetail(
      SearchCarInputModel searchCarInputModel) async {
    String url = Common.apiGetFavoriteCar;

    var params = <String, dynamic>{
      'memberNum': searchCarInputModel.memberNum,
      'userNum': searchCarInputModel.userNum,
      'corner': searchCarInputModel.corner,
      'aACount': searchCarInputModel.aACount,
      'exhNum': searchCarInputModel.exhNum,
      'carNo': searchCarInputModel.carNo,
      'makerCode': searchCarInputModel.makerCode
    };

    final response = await BaseDio.instance
        .request<List<SearchCarModel>>(url, MethodType.GET, data: params);

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
