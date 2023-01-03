import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/sell_car/domain/repositories/sell_car_repository.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../../new_question/data/models/upload_photo_response.dart';
import '../../data/model/sell_car_upload_photo_request.dart';

class UploadPhotoSellCar extends UseCaseExtend<List<UploadPhotoResponseModel>?,
    SellCarUploadPhotoRequestModel> {
  final SellCarRepository repository;

  UploadPhotoSellCar(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<UploadPhotoResponseModel>?>> call(
      SellCarUploadPhotoRequestModel params) async {
    return await repository.uploadPhoto(params);
  }
}
