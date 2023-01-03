import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_request_model.dart';
import 'package:mirukuru/features/my_page/domain/repositories/my_page_repository.dart';

class GetMyPageInformation
    implements UseCaseExtend<MyPageModel?, MyPageRequestModel> {
  final MyPageRepository repository;

  GetMyPageInformation(this.repository);

  @override
  Future<Either<ReponseErrorModel, MyPageModel?>> call(
      MyPageRequestModel params) async {
    return await repository.getMyPageInformation(params);
  }
}
