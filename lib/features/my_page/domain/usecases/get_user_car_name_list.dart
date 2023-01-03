import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_request_model.dart';
import 'package:mirukuru/features/my_page/domain/repositories/my_page_repository.dart';

class GetUserCarNameList
    implements
        UseCaseExtend<List<UserCarNameModel>?, List<UserCarNameRequestModel>> {
  final MyPageRepository repository;

  GetUserCarNameList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<UserCarNameModel>?>> call(
      List<UserCarNameRequestModel> params) {
    return repository.getUserCaNameList(params);
  }
}
