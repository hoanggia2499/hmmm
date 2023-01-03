import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/new_question/domain/responsitories/new_question_reponsitory.dart';

class GetLocalData extends UseCaseExtend<List<NameBeanHive>, NoParamsExt> {
  final NewQuestionRepository repository;

  GetLocalData(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> call(
      NoParamsExt params) async {
    return await repository.getLocalData();
  }
}
