import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/question/data/models/question_bean_param.dart';
import 'package:mirukuru/features/question/domain/usecases/delete_question.dart';
import 'package:mirukuru/features/question/domain/usecases/get_question.dart';
import 'package:mirukuru/features/app_bloc/paginated_data_bloc_mixin.dart';
import 'package:mirukuru/features/question/presentation/bloc/question_event.dart';
import 'package:mirukuru/features/question/presentation/bloc/question_state.dart';
import 'package:easy_localization/easy_localization.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState>
    with PaginatedDataBlocMixin<QuestionBean> {
  final GetQuestion getQuestions;
  final DeleteQuestion deleteQuestion;

  late QuestionBeanParam questionParam;

  QuestionBeanParam get getQuestionParam => this.questionParam;

  set setQuestionParam(QuestionBeanParam questionParam) =>
      this.questionParam = questionParam;

  QuestionBloc(this.getQuestions, this.deleteQuestion) : super(Empty()) {
    on<LoadQuestions>(_onLoadQuestionList);
    on<DeleteQuestionInit>(_onDeleteQuestion);
  }

  Future _onLoadQuestionList(
      LoadQuestions event, Emitter<QuestionState> emit) async {
    emit(Loading());
    try {
      questionParam = event.questionBeanParam;
      if (!hasMoreData) {
        emit(QuestionListState(result: []));
      }

      final callGetAgreement = await loadData(
          loadPageIndex: event.isLoadAll ? 0 : loadPageIndex,
          pageSize: this.pageSize);

      await callGetAgreement.fold((responseFail) async {
        Logging.log.warn(responseFail);

        if (responseFail.msgCode.contains('5MA002SE')) {
          emit(TimeOut(
              messageCode: responseFail.msgCode,
              messageContent: responseFail.msgContent));
        } else {
          emit(Error(
              messageCode: responseFail.msgCode,
              messageContent: responseFail.msgContent));
        }
        return false;
      }, (responseSuccess) async {
        updatePaginatedDataParams(
            responseSuccess.data, responseSuccess.totalCount);
        emit(QuestionListState(result: data));
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onDeleteQuestion(
      DeleteQuestionInit event, Emitter<QuestionState> emit) async {
    emit(Loading());
    try {
      // call API get agreement
      final callGetAgreement = await deleteQuestion(event.deleteQuestionParam);

      await callGetAgreement.fold((responseFail) async {
        Logging.log.warn(responseFail);

        if (responseFail.msgCode.contains('5MA002SE')) {
          emit(TimeOut(
              messageCode: responseFail.msgCode,
              messageContent: responseFail.msgContent));
        } else {
          emit(Error(
              messageCode: responseFail.msgCode,
              messageContent: responseFail.msgContent));
        }
        return false;
      }, (responseSuccess) async {
        List<DeletedQuestion> deletedQuestions = [];

        if (event.deleteQuestionParam.ids != null &&
            event.deleteQuestionParam.nums != null) {
          int length = min(event.deleteQuestionParam.ids!.length,
              event.deleteQuestionParam.nums!.length);
          for (int i = 0; i < length; i++) {
            deletedQuestions.add(DeletedQuestion(
                id: event.deleteQuestionParam.ids![i],
                questionNum: event.deleteQuestionParam.nums![i]));
          }
        }

        emit(DeleteQuestionState(deletedQuestions: deletedQuestions));
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>> loadData(
      {required int loadPageIndex, required int pageSize}) {
    var param =
        questionParam.copyWith(pageIndex: loadPageIndex, pageSize: pageSize);
    return getQuestions(param);
  }
}
