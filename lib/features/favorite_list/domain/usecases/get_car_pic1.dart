import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/data/models/item_car_pic1_model.dart';

import '../repositories/favorite_list_repository.dart';

class GetCarPic1InFavorite
    implements UseCaseExtend<List<ItemCarPic1Model>, NoParamsExt> {
  final FavoriteListRepository repository;

  GetCarPic1InFavorite(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemCarPic1Model>>> call(
      NoParamsExt params) async {
    return await repository.getCarPic1();
  }
}
