import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/sell_car/domain/repositories/sell_car_repository.dart';

class SellCarGetLocalData
    extends UseCaseExtend<List<NameBeanHive>, NoParamsExt> {
  final SellCarRepository repository;

  SellCarGetLocalData(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> call(
      NoParamsExt params) async {
    return await repository.getLocalData();
  }
}
