import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/question/data/models/delete_question_param.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean_param.dart';
import '../../../../core/error/error_model.dart';

abstract class QuestionDataSource {
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>>
      getQuestionList(QuestionBeanParam questionBeanParam);

  Future<Either<ReponseErrorModel, String>> deleteQuestion(
      DeleteQuestionParam questionBeanParam);
}

class QuestionDataSourceImpl implements QuestionDataSource {
  QuestionDataSourceImpl();

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>>
      getQuestionList(QuestionBeanParam questionBeanParam) async {
    String url = Common.listQuestionUrl;

    final response = await BaseDio.instance
        .request<PaginatedDataModel<QuestionBean>>(url, MethodType.GET,
            data: questionBeanParam.toMap());

    var responseError = ReponseErrorModel(
      msgCode: response.messageCode,
      msgContent: response.messageContent,
    );

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          return Left(responseError);
        }
        return Right(response.data!);
      default:
        return Left(responseError);
    }
  }

  @override
  Future<Either<ReponseErrorModel, String>> deleteQuestion(
      DeleteQuestionParam questionBeanParam) async {
    String url = Common.apiDeleteQuestion;

    var params = <String, dynamic>{
      'memberNum': questionBeanParam.memberNum,
      'userNum': questionBeanParam.userNum,
      'nums': questionBeanParam.nums,
      'ids': questionBeanParam.ids
    };

    final response = await BaseDio.instance
        .request<String>(url, MethodType.DELETE, data: params);

    var responseError = ReponseErrorModel(
      msgCode: response.messageCode,
      msgContent: response.messageContent,
    );

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          return Left(responseError);
        }
        return Right(response.data!);
      default:
        return Left(responseError);
    }
  }
}
