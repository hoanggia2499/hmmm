import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/car_regist/domain/repositories/car_regist_repository.dart';
import '../../../../core/error/error_model.dart';
import '../../data/model/get_car_images_request.dart';

class GetListImage
    implements UseCaseExtend<List<String>, GetCarImagesRequestModel> {
  final CarRegistRepository repository;

  GetListImage(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<String>>> call(
      GetCarImagesRequestModel request) async {
    return await repository.getListImage(request);
  }
}
