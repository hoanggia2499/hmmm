import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/question/data/models/delete_question_param.dart';
import 'package:mirukuru/features/question/domain/repositories/question_repository.dart';

class DeleteQuestion implements UseCaseExtend<String, DeleteQuestionParam> {
  final QuestionRepository repository;

  DeleteQuestion(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      DeleteQuestionParam params) async {
    return await repository.deleteQuestion(params);
  }
}
