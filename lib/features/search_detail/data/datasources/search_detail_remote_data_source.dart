import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';

abstract class SearchDetailDataSource {
  Future<List<SearchCarModel>?> getSeachDetail(
      SearchCarInputModel searchCarInputModel);
  Future<String?> getFavoriteAccess(FavoriteAccessModel favoriteAccessModel);
}

class SearchDetailDataSourceImpl implements SearchDetailDataSource {
  SearchDetailDataSourceImpl();

  @override
  Future<List<SearchCarModel>?> getSeachDetail(
      SearchCarInputModel searchCarInputModel) async {
    String url = Common.apiGetSearchCar;

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

  @override
  Future<String?> getFavoriteAccess(
      FavoriteAccessModel favoriteAccessModel) async {
    String url = Common.favoriteUrl;

    var params = <String, dynamic>{
      'MemberNum': favoriteAccessModel.memberNum,
      'UserNum': favoriteAccessModel.userNum,
      'ExhNum': favoriteAccessModel.exhNum,
      'MakerCode': favoriteAccessModel.makerCode,
      'CarName': favoriteAccessModel.carName
    };

    final response = await BaseDio.instance
        .request<String>(url, MethodType.POST, data: params);

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
