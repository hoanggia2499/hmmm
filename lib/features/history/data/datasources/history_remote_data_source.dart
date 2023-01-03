import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class HistoryRemoteDataSource {
  Future<String?> getFavoriteAccess(FavoriteAccessModel favoriteAccessModel);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  HistoryRemoteDataSourceImpl();

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
