import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import '../../../../core/error/error_model.dart';
import '../../../new_question/data/models/upload_photo_response.dart';
import '../../data/model/sell_car_delete_photo_request.dart';
import '../../data/model/sell_car_get_list_image.dart';
import '../../data/model/sell_car_model.dart';
import '../../data/model/sell_car_upload_photo_request.dart';

abstract class SellCarRepository {
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> getLocalData();
  Future<Either<ReponseErrorModel, String>> postSellCar(SellCarModel request);
  Future<Either<ReponseErrorModel, String>> deletePhoto(
      SellCarDeleteSinglePhotoRequestModel request);
  Future<Either<ReponseErrorModel, String>> deleteMultiPhoto(
      List<SellCarDeleteSinglePhotoRequestModel> request);
  Future<Either<ReponseErrorModel, List<UploadPhotoResponseModel>?>>
      uploadPhoto(SellCarUploadPhotoRequestModel request);
  Future<Either<ReponseErrorModel, List<String>>> getListImage(
      SellCarGetCarImagesRequestModel request);
}
