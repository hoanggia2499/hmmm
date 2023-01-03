import 'package:dartz/dartz.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../data/model/sell_car_model.dart';
import '../repositories/sell_car_repository.dart';

class PostSellCar extends UseCaseExtend<String, SellCarModel> {
  final SellCarRepository repository;

  PostSellCar(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(SellCarModel params) async {
    return await repository.postSellCar(params);
  }
}
