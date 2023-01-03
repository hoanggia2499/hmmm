import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_response_model.dart';
import 'package:mirukuru/features/message_board/domain/repositories/photo_repository.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';

class UploadPhotoCarRegis extends UseCaseExtend<List<PhotoUploadResponseModel>?,
    PhotoUploadRequestModel> {
  final PhotoRepository photoRepository;

  UploadPhotoCarRegis(this.photoRepository);

  @override
  Future<Either<ReponseErrorModel, List<PhotoUploadResponseModel>?>> call(
      PhotoUploadRequestModel params) async {
    return await photoRepository.uploadPhoto(params);
  }
}
