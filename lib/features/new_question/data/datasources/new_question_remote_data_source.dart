import 'package:dio/dio.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/new_question/data/models/delete_photo_request.dart';
import 'package:mirukuru/features/new_question/data/models/new_question_request.dart';
import 'package:mirukuru/features/new_question/data/models/upload_photo_request.dart';

import '../../../../core/config/common.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_base.dart';
import '../../../../core/network/task_type.dart';
import '../../../my_page/data/models/user_car_name_model.dart';
import '../../../my_page/data/models/user_car_name_request_model.dart';
import '../models/upload_photo_response.dart';
import '../models/user_info_request_model.dart';
import '../models/user_info_response_model.dart';

abstract class NewQuestionRemoteDataSource {
  Future<UserInfoResponseModel?> getUserInfo(UserInfoRequestModel request);

  Future<List<UserCarNameModel>?> getCarList(
      List<UserCarNameRequestModel> request);

  Future<String> postNewQuestion(NewQuestionRequestModel request);

  Future<String> deletePhotoAfterPosted(DeletePhotoRequestModel request);

  Future<List<UploadPhotoResponseModel>?> uploadPhoto(
      UploadPhotoRequestModel request);
}

class NewQuestionRemoteDataSourceImpl implements NewQuestionRemoteDataSource {
  @override
  Future<UserInfoResponseModel?> getUserInfo(
      UserInfoRequestModel request) async {
    String url = Common.userUrl;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum
    };

    final response = await BaseDio.instance
        .request<UserInfoResponseModel?>(url, MethodType.GET, data: params);

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
  Future<List<UserCarNameModel>?> getCarList(
      List<UserCarNameRequestModel> request) async {
    String url = Common.apiGetCarNamesV2;

    var requestValues = request.map((e) => (e).toJson()).toList();
    final params = Map<String, List<String>>();
    params.putIfAbsent('carNameRequest', () => requestValues);

    final response = await BaseDio.instance
        .request<List<UserCarNameModel>>(url, MethodType.GET, data: params);

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
  Future<String> postNewQuestion(NewQuestionRequestModel request) async {
    String url = Common.questionUrl;

    var params = <String, dynamic>{
      "memberNum": request.memberNum,
      "userNum": request.userNum,
      "exhNum": request.exhNum,
      "userCarNum": request.userCarNum,
      "makerCode": request.makerCode,
      "makerName": request.makerName,
      "carName": request.carName,
      "id": request.id,
      "question": request.question,
      "questionKbn": request.questionKbn,
    };

    final response =
        await BaseDio.instance.request(url, MethodType.POST, data: params);

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
  Future<String> deletePhotoAfterPosted(DeletePhotoRequestModel request) async {
    String url = Common.apiDeleteListPhotos;

    var params = <String, dynamic>{
      "memberNum": request.memberNum,
      "userNum": request.userNum,
      "userCarNum": request.userCarNum,
      "upKind": request.upKind
    };

    /// method delete used for param
    var realUrl = HelperFunction.instance.formatRealUrl(url, params);

    final response = await BaseDio.instance.request(
      realUrl,
      MethodType.DELETE,
      data: <String, dynamic>{},
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
  Future<List<UploadPhotoResponseModel>?> uploadPhoto(
      UploadPhotoRequestModel request) async {
    String url = Common.apiUploadFile;

    var _listFile = request.files
        ?.map((e) =>
            MultipartFile.fromFileSync(e?.path ?? "", filename: e?.name ?? ""))
        .toList();

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
