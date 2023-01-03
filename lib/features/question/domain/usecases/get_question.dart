import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean_param.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/question_repository.dart';

class GetQuestion
    implements
        UseCaseExtend<PaginatedDataModel<QuestionBean>, QuestionBeanParam> {
  final QuestionRepository repository;

  GetQuestion(this.repository);

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>> call(
      QuestionBeanParam params) async {
    return await repository.getQuestion(params);
  }
}
