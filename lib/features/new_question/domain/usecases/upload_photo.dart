import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/new_question/domain/responsitories/new_question_reponsitory.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../data/models/upload_photo_response.dart';
import '../../data/models/new_question_model.dart';

class UploadPhoto
    extends UseCaseExtend<List<UploadPhotoResponseModel>?, NewQuestionModel> {
  final NewQuestionRepository repository;

  UploadPhoto(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<UploadPhotoResponseModel>?>> call(
      NewQuestionModel params) async {
    return await repository.uploadPhoto(params);
  }
}
