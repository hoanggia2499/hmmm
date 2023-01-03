import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/network/paginated_data_request_model.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/question/data/models/question_bean.dart';
import 'package:mirukuru/features/app_bloc/paginated_data_bloc_mixin.dart';
import 'package:mirukuru/features/quotation_list/domain/usecases/get_quotation_list.dart';
import 'package:mirukuru/features/quotation_list/presentation/bloc/quotation_list_event.dart';
import 'package:mirukuru/features/quotation_list/presentation/bloc/quotation_list_state.dart';
import 'package:easy_localization/easy_localization.dart';

class QuotationListBloc extends Bloc<QuotationListEvent, QuotationListState>
    with PaginatedDataBlocMixin<QuestionBean> {
  final GetQuotationList getEstimateRequests;

  QuotationListBloc(this.getEstimateRequests) : super(Empty()) {
    on<QuotationListInit>(_onRequestQuotationInit);
  }

  Future _onRequestQuotationInit(
      QuotationListInit event, Emitter<QuotationListState> emit) async {
    emit(Loading());
    try {
      if (!hasMoreData) {
        emit(Loaded(listQuestionBean: []));
      }

      final callGetAgreement = await loadData(
          loadPageIndex: this.loadPageIndex, pageSize: this.pageSize);

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
        emit(Loaded(listQuestionBean: responseSuccess.data));
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<QuestionBean>>> loadData(
      {required int loadPageIndex, required int pageSize}) {
    return getEstimateRequests(PaginatedDataRequestModel(
        pageIndex: loadPageIndex, pageSize: pageSize));
  }
}
