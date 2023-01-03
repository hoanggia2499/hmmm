import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/new_question/domain/responsitories/new_question_reponsitory.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../data/models/new_question_model.dart';

class PostNewQuestionNow extends UseCaseExtend<String, NewQuestionModel> {
  final NewQuestionRepository repository;

  PostNewQuestionNow(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      NewQuestionModel params) async {
    return await repository.postNewQuestion(params);
  }
}
