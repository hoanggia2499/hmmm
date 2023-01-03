import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/message_board/data/models/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/message_board/domain/repositories/photo_repository.dart';

class DeletePhoto
    extends UseCaseExtend<String, List<DeleteSinglePhotoRequestModel>> {
  final PhotoRepository photoRepository;

  DeletePhoto(this.photoRepository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      List<DeleteSinglePhotoRequestModel> params) async {
    if (params.length == 1) {
      return await photoRepository.deletePhoto(params.first);
    }
    return await photoRepository.deleteMultiPhoto(params);
  }
}
