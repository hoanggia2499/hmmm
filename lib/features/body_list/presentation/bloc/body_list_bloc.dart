import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/body_list/domain/usecases/get_body_list.dart';
import 'package:mirukuru/features/body_list/presentation/bloc/body_list_event.dart';
import 'package:mirukuru/features/body_list/presentation/bloc/body_list_state.dart';

class BodyListBloc extends Bloc<BodyListEvent, BodyListState> {
  final GetBodyList getBodyList;

  BodyListBloc(this.getBodyList) : super(Empty()) {
    on<GetBodyListEvent>(_onAgreementInit);
  }

  Future _onAgreementInit(
      GetBodyListEvent event, Emitter<BodyListState> emit) async {
    emit(Loading());
    try {
      // call API get agreement
      final callGetAgreement = await getBodyList(event.id);

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
        emit(Loaded(listBodyModel: responseSuccess));
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }
}
