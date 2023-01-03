import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/question/data/datasources/question_remote_data_source.dart';
import 'package:mirukuru/features/question/data/models/delete_question_param.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean_param.dart';
import '../../../../core/error/error_model.dart';
import '../../domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionDataSource agreementDataSource;

  QuestionRepositoryImpl({
    required this.agreementDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>>
      getQuestion(QuestionBeanParam questionBeanParam) async {
    if (await InternetConnection.instance.isHasConnection()) {
      return await agreementDataSource.getQuestionList(questionBeanParam);
    } else {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, String>> deleteQuestion(
      DeleteQuestionParam questionBeanParam) async {
    if (await InternetConnection.instance.isHasConnection()) {
      return await agreementDataSource.deleteQuestion(questionBeanParam);
    } else {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
    }
  }
}
