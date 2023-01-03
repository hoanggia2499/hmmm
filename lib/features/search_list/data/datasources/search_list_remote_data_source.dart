import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_car_pic1_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_of_quotation_request.dart';

abstract class SearchListRemoteDataSource {
  Future<PaginatedDataModel<ItemSearchModel>?> getSearchList(
      SearchListModel searchListModel);

  Future<List<ItemCarPic1Model>?> getCarPic1();

  Future<String?> getNumberOfQuotationToday(
      NumberOfQuotationRequestModel request);

  Future<String?> getFavoriteAccess(FavoriteAccessModel favoriteAccessModel);
}

class SearchListRemoteDataSourceImpl implements SearchListRemoteDataSource {
  SearchListRemoteDataSourceImpl();

  @override
  Future<PaginatedDataModel<ItemSearchModel>?> getSearchList(
      SearchListModel searchListModel) async {
    String url = Common.apiGetSearchCar2;

    var params = <String, dynamic>{
      'MemberNum': searchListModel.memberNum,
      'CallCount': searchListModel.callCount,
      'MakerCode1': searchListModel.makerCode1,
      'MakerCode2': searchListModel.makerCode2,
      'MakerCode3': searchListModel.makerCode3,
      'MakerCode4': searchListModel.makerCode4,
      'MakerCode5': searchListModel.makerCode5,
      'CarName1': searchListModel.carName1,
      'CarName2': searchListModel.carName2,
      'CarName3': searchListModel.carName3,
      'CarName4': searchListModel.carName4,
      'CarName5': searchListModel.carName5,
      'Nenshiki1': searchListModel.nenshiki1,
      'Nenshiki2': searchListModel.nenshiki2,
      'Distance1': searchListModel.distance1,
      'Distance2': searchListModel.distance2,
      'Haikiryou1': searchListModel.haikiryou1,
      'Haikiryou2': searchListModel.haikiryou2,
      'Price1': searchListModel.price1,
      'Price2': searchListModel.price2,
      'Inspection': searchListModel.inspection,
      'Repair': searchListModel.repair,
      'Mission': searchListModel.mission,
      'Freeword': searchListModel.freeword,
      'Color': searchListModel.color,
      'Area': searchListModel.area,
      'per_page': searchListModel.pageSize,
      'page': searchListModel.pageIndex
    };

    final response = await BaseDio.instance
        .request<PaginatedDataModel<ItemSearchModel>>(url, MethodType.GET,
            data: params);

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
  Future<List<ItemCarPic1Model>?> getCarPic1() async {
    String url = Common.apiGetCarPic1;

    final response = await BaseDio.instance
        .request<List<ItemCarPic1Model>>(url, MethodType.GET);

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
  Future<String?> getNumberOfQuotationToday(
      NumberOfQuotationRequestModel request) async {
    String url = Common.apiNumberOfQuotationToday;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum
    };

    final response =
        await BaseDio.instance.request<int>(url, MethodType.GET, data: params);

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data.toString();
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
