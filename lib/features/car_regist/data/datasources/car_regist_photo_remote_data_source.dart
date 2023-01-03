import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/image_util.dart';
import 'package:mirukuru/features/car_regist/data/model/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/car_regist/data/model/delete_photo_request_model.dart';
import 'package:mirukuru/features/car_regist/data/model/get_car_images_request.dart';
import 'package:mirukuru/features/car_regist/data/model/upload_photo_request_model.dart';
import 'package:mirukuru/features/car_regist/data/model/upload_photo_response_model.dart';

abstract class CarRegisPhotoRemoteDataSource {
  Future<String> deleteAllPhoto(DeletePhotoRequestModel request);
  Future<String> deletePhoto(DeleteSinglePhotoRequestModel request);
  Future<List<PhotoUploadResponseModel>?> uploadPhoto(
      PhotoUploadRequestModel request);
  Future<List<String>?> getListImage(GetCarImagesRequestModel request);
}

class CarRegisPhotoRemoteDataSourceImpl extends CarRegisPhotoRemoteDataSource {
  @override
  Future<List<String>?> getListImage(GetCarImagesRequestModel request) async {
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
  Future<String> deleteAllPhoto(DeletePhotoRequestModel request) async {
    String url = Common.apiDeleteListPhotos;

    var params = <String, dynamic>{
      "memberNum": request.memberNum,
      "userNum": request.userNum,
      "userCarNum": request.userCarNum,
      "upKind": request.upKind
    };

    var realUrl = HelperFunction.instance.formatRealUrl(url, params);

    final response = await BaseDio.instance
        .request(realUrl, MethodType.DELETE, data: params);

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
  Future<String> deletePhoto(DeleteSinglePhotoRequestModel request) async {
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
  Future<List<PhotoUploadResponseModel>?> uploadPhoto(
      PhotoUploadRequestModel request) async {
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
        await BaseDio.instance.uploadFile<List<PhotoUploadResponseModel>>(
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
