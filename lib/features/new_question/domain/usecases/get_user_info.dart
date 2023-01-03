import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/new_question/domain/responsitories/new_question_reponsitory.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../data/models/user_info_request_model.dart';
import '../../data/models/user_info_response_model.dart';

class GetUserInfo
    implements UseCaseExtend<UserInfoResponseModel?, UserInfoRequestModel> {
  final NewQuestionRepository repository;

  GetUserInfo(this.repository);

  @override
  Future<Either<ReponseErrorModel, UserInfoResponseModel?>> call(
      UserInfoRequestModel params) async {
    return await repository.getUserInfo(params);
  }
}
