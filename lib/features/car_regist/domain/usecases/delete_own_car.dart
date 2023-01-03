import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/car_regist/domain/repositories/car_regist_repository.dart';
import '../../../../core/error/error_model.dart';
import '../../data/model/delete_own_car_request.dart';

class DeleteOwnCar implements UseCaseExtend<String, DeleteOwnCarRequestModel> {
  final CarRegistRepository repository;

  DeleteOwnCar(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      DeleteOwnCarRequestModel request) async {
    return await repository.deleteOwnCar(request);
  }
}
