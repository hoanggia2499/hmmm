import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import '../../data/model/sell_car_delete_photo_request.dart';
import '../repositories/sell_car_repository.dart';

class DeletePhotoAfterPostedSellCar
    extends UseCaseExtend<String, List<SellCarDeleteSinglePhotoRequestModel>> {
  final SellCarRepository sellCarRepository;

  DeletePhotoAfterPostedSellCar(this.sellCarRepository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      List<SellCarDeleteSinglePhotoRequestModel> params) async {
    if (params.length == 1) {
      return await sellCarRepository.deletePhoto(params.first);
    }
    return await sellCarRepository.deleteMultiPhoto(params);
  }
}
