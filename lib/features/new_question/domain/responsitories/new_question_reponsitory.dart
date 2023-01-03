import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';

import '../../../../core/error/error_model.dart';
import '../../../my_page/data/models/user_car_name_model.dart';
import '../../../my_page/data/models/user_car_name_request_model.dart';
import '../../data/models/upload_photo_response.dart';
import '../../data/models/user_info_request_model.dart';
import '../../data/models/user_info_response_model.dart';
import '../../data/models/new_question_model.dart';

abstract class NewQuestionRepository {
  Future<Either<ReponseErrorModel, UserInfoResponseModel?>> getUserInfo(
      UserInfoRequestModel request);
  Future<Either<ReponseErrorModel, List<UserCarNameModel>?>> getCarList(
      List<UserCarNameRequestModel> request);
  Future<Either<ReponseErrorModel, String>> postNewQuestion(
      NewQuestionModel request);
  Future<Either<ReponseErrorModel, String>> deletePhotoAfterPosted(
      NewQuestionModel request);
  Future<Either<ReponseErrorModel, List<UploadPhotoResponseModel>?>>
      uploadPhoto(NewQuestionModel request);
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> getLocalData();
}
