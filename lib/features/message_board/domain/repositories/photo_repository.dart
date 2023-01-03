import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/message_board/data/models/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/message_board/data/models/delete_photo_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/get_image_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_response_model.dart';

abstract class PhotoRepository {
  Future<Either<ReponseErrorModel, List<String>?>> getMessageBoardImages(
      GetImageRequestModel request);
  Future<Either<ReponseErrorModel, String>> deletePhoto(
      DeleteSinglePhotoRequestModel request);
  Future<Either<ReponseErrorModel, List<PhotoUploadResponseModel>?>>
      uploadPhoto(PhotoUploadRequestModel request);
  Future<Either<ReponseErrorModel, String>> deleteMultiPhoto(
      List<DeleteSinglePhotoRequestModel> request);
  Future<Either<ReponseErrorModel, String>> deleteAllPhoto(
      DeletePhotoRequestModel request);
}
