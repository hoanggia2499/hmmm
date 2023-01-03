import 'package:dartz/dartz.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../../my_page/data/models/user_car_name_model.dart';
import '../../../my_page/data/models/user_car_name_request_model.dart';
import '../responsitories/new_question_reponsitory.dart';

class GetNewQuestionCarList
    implements
        UseCaseExtend<List<UserCarNameModel>?, List<UserCarNameRequestModel>> {
  final NewQuestionRepository repository;

  GetNewQuestionCarList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<UserCarNameModel>?>> call(
      List<UserCarNameRequestModel> params) {
    return repository.getCarList(params);
  }
}
