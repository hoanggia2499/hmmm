import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_update_model.dart';
import 'package:mirukuru/features/my_page/domain/repositories/my_page_repository.dart';

class SaveMyPageInformation
    implements UseCaseExtend<String, MyPageUpdateModel> {
  final MyPageRepository repository;

  SaveMyPageInformation(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      MyPageUpdateModel inputModel) async {
    return repository.saveMyPageInformation(inputModel);
  }
}
