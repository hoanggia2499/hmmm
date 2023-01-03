import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/car_regist/data/model/post_own_car_request.dart';
import 'package:mirukuru/features/car_regist/domain/repositories/car_regist_repository.dart';
import '../../../../core/error/error_model.dart';
import '../../data/model/post_own_car_response.dart';

class PostOwnCar
    implements UseCaseExtend<PostOwnCarResponse, PostOwnCarRequestModel> {
  final CarRegistRepository repository;

  PostOwnCar(this.repository);

  @override
  Future<Either<ReponseErrorModel, PostOwnCarResponse>> call(
      PostOwnCarRequestModel request) async {
    return await repository.postOwnCar(request);
  }
}
