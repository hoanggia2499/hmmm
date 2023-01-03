import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/image_util.dart';

import '../../../new_question/data/models/upload_photo_response.dart';
import '../model/sell_car_delete_photo_request.dart';
import '../model/sell_car_get_list_image.dart';
import '../model/sell_car_upload_photo_request.dart';

abstract class SellCarPhotoDataSource {
  Future<String> deletePhoto(SellCarDeleteSinglePhotoRequestModel request);
  Future<List<UploadPhotoResponseModel>?> uploadPhoto(
      SellCarUploadPhotoRequestModel request);
  Future<List<String>?> getListImage(SellCarGetCarImagesRequestModel request);
}

class SellCarPhotoDataSourceImpl extends SellCarPhotoDataSource {
  @override
  Future<List<String>?> getListImage(
      SellCarGetCarImagesRequestModel request) async {
    String url = Common.imagesProcessUrl;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum,
      'userCarNum': request.userCarNum,
      "upKind": request.upKind
    };

    final response = await BaseDio.instance
        .request<List<String>>(url, MethodType.GET, data: params);

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
  Future<String> deletePhoto(
      SellCarDeleteSinglePhotoRequestModel request) async {
    String url = Common.apiDeletePhoto;

    var realUrl = HelperFunction.instance.formatRealUrl(url, request.toMap());

    final response = await BaseDio.instance
        .request(realUrl, MethodType.DELETE, data: request.toMap());

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
  Future<List<UploadPhotoResponseModel>?> uploadPhoto(
      SellCarUploadPhotoRequestModel request) async {
    String url = Common.apiUploadFile;

    var _listFile = ImageUtil.instance.convertFromXFiles(request.files);

    var params = <String, dynamic>{
      "memberNum": request.memberNum,
      "userNum": request.userNum,
      "userCarNum": request.userCarNum,
      "upKind": request.upKind,
      "files": _listFile
    };

    final response =
        await BaseDio.instance.uploadFile<List<UploadPhotoResponseModel>>(
      url,
      param: params,
    );

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
