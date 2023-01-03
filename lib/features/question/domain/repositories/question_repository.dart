import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/features/question/data/models/delete_question_param.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean_param.dart';
import '../../../../core/error/error_model.dart';

abstract class QuestionRepository {
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>>
      getQuestion(QuestionBeanParam questionBeanParam);
  Future<Either<ReponseErrorModel, String>> deleteQuestion(
      DeleteQuestionParam questionBeanParam);
}
