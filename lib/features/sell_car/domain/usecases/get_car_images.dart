import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import '../../../../core/error/error_model.dart';
import '../../data/model/sell_car_get_list_image.dart';
import '../repositories/sell_car_repository.dart';

class GetListImageSellCar
    implements UseCaseExtend<List<String>, SellCarGetCarImagesRequestModel> {
  final SellCarRepository repository;

  GetListImageSellCar(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<String>>> call(
      SellCarGetCarImagesRequestModel request) async {
    return await repository.getListImage(request);
  }
}
