import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/image_util.dart';
import 'package:mirukuru/features/message_board/data/models/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/message_board/data/models/delete_photo_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/get_image_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_response_model.dart';

abstract class PhotoRemoteDataSource {
  Future<String> deleteAllPhoto(DeletePhotoRequestModel request);
  Future<String> deletePhoto(DeleteSinglePhotoRequestModel request);
  Future<List<PhotoUploadResponseModel>?> uploadPhoto(
      PhotoUploadRequestModel request);
  Future<List<String>?> getPhotos(GetImageRequestModel request);
}

class PhotoRemoteDataSourceImpl extends PhotoRemoteDataSource {
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

  @override
  Future<List<String>?> getPhotos(GetImageRequestModel request) async {
    String url = Common.imagesProcessUrl;

    final response = await BaseDio.instance
        .request<List<String>>(url, MethodType.GET, data: request.toMap());

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
