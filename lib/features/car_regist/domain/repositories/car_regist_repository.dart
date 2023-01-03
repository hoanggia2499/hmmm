import 'package:dartz/dartz.dart';
import '../../../../core/error/error_model.dart';
import '../../data/model/local_data_model.dart';
import '../../data/model/delete_own_car_request.dart';
import '../../data/model/get_car_images_request.dart';
import '../../data/model/post_own_car_request.dart';
import '../../data/model/post_own_car_response.dart';
import 'package:mirukuru/features/car_regist/data/model/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/car_regist/data/model/upload_photo_request_model.dart';
import 'package:mirukuru/features/car_regist/data/model/upload_photo_response_model.dart';

abstract class CarRegistRepository {
  Future<Either<ReponseErrorModel, LocalModel>> getLocalData();
  Future<Either<ReponseErrorModel, List<String>>> getListImage(
      GetCarImagesRequestModel request);
  Future<Either<ReponseErrorModel, String>> deleteOwnCar(
      DeleteOwnCarRequestModel request);
  Future<Either<ReponseErrorModel, PostOwnCarResponse>> postOwnCar(
      PostOwnCarRequestModel request);
  Future<Either<ReponseErrorModel, String>> deletePhoto(
      DeleteSinglePhotoRequestModel request);
  Future<Either<ReponseErrorModel, List<PhotoUploadResponseModel>?>>
      uploadPhoto(PhotoUploadRequestModel request);
  Future<Either<ReponseErrorModel, String>> deleteMultiPhoto(
      List<DeleteSinglePhotoRequestModel> request);
}
