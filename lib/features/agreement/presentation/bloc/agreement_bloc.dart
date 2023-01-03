import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../domain/usecases/get_agreement.dart';
import '../../domain/usecases/send_mail_new_user.dart';
import 'agreement_event.dart';
import 'agreement_state.dart';

class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  final GetAgreement getAgreement;
  final SendMailNewUser sendMailNewUser;

  AgreementBloc(this.getAgreement, this.sendMailNewUser) : super(Empty()) {
    on<AgreeInit>(_onAgreementInit);
    on<SendMailNewUserSubmitted>(_onSendMailNewUserSubmitted);
  }

  Future _onAgreementInit(AgreeInit event, Emitter<AgreementState> emit) async {
    emit(Loading());
    try {
      // call API get agreement
      final callGetAgreement = await getAgreement(NoParamsExt());

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
        // set format string value agreement
        responseSuccess =
            responseSuccess.trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");

        emit(Loaded(agreement: responseSuccess));
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onSendMailNewUserSubmitted(
      SendMailNewUserSubmitted event, Emitter<AgreementState> emit) async {
    emit(Loading());
    try {
      // call API38 SendMailNewUser
      final callApiSendMail = await sendMailNewUser(
          ParamRequests(memberNum: event.memberNum, userNum: event.userNum));

      callApiSendMail.fold((requestFail) async {
        emit(Error(
            messageCode: requestFail.msgCode,
            messageContent: requestFail.msgContent));
      }, (requestSuccess) async {
        emit(SendMailState());
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: ''));
    }
  }
}
