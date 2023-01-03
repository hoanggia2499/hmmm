import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/car_regist/domain/repositories/car_regist_repository.dart';

import '../../data/model/local_data_model.dart';

class GetListRIKUJI extends UseCaseExtend<LocalModel, NoParamsExt> {
  final CarRegistRepository repository;

  GetListRIKUJI(this.repository);

  @override
  Future<Either<ReponseErrorModel, LocalModel>> call(NoParamsExt params) async {
    return await repository.getLocalData();
  }
}
