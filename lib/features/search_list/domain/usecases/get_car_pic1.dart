import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/data/models/item_car_pic1_model.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

class GetCarPic1 implements UseCaseExtend<List<ItemCarPic1Model>, NoParamsExt> {
  final SearchListRepository repository;

  GetCarPic1(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemCarPic1Model>>> call(
      NoParamsExt params) async {
    return await repository.getCarPic1();
  }
}
