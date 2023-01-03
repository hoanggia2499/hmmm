import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/login/domain/usecases/post_login.dart';
import 'package:mirukuru/features/new_user_authentication/domain/usecases/new_user_authentication.dart';
import 'package:mirukuru/features/new_user_registration/domain/usecases/personal_register.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';

part 'new_user_authentication_event.dart';
part 'new_user_authentication_state.dart';

class NewUserAuthenticationBloc
    extends Bloc<NewUserAuthenticationEvent, NewUserAuthenticationState> {
  final NewUserAuthentication requestNewUserAuthentication;
  final PostLogin postLogin;
  final PersonalRegister personalRegister;

  NewUserAuthenticationBloc(
      this.requestNewUserAuthentication, this.postLogin, this.personalRegister)
      : super(Empty()) {
    on<UserAuthenticationSubmitted>(_onAgreementInit);
    on<LoginSubmitted>(appLoginSetting);
    on<PersonalRegisterEvent>(callAPIPersonalRegister);
  }

  Future _onAgreementInit(UserAuthenticationSubmitted event,
      Emitter<NewUserAuthenticationState> emit) async {
    emit(Loading());
    try {
      // call API request Authentication
      final callRequestAuthentication = await requestNewUserAuthentication(
          Params(id: event.id, tel: event.tel, authCode: event.code));

      callRequestAuthentication.fold((responseFail) {
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
      }, (responseSuccess) {
        // set format string value agreement
        responseSuccess =
            responseSuccess.trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");

        if (responseSuccess == 'EXISTS_ERROR') {
          emit(AlreadyExists());
        } else {
          emit(Authenticated());
        }
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  // call API45 PersonalRegister
  Future callAPIPersonalRegister(PersonalRegisterEvent event,
      Emitter<NewUserAuthenticationState> emit) async {
    final userPersonalRegister = await personalRegister(ParamPersonal(
        id: event.id,
        tel: event.tel,
        userName: event.name,
        userNameKana: event.nameKana));

    userPersonalRegister.fold((requestFail) {
      emit(Error(
          messageCode: requestFail.msgCode,
          messageContent: requestFail.msgContent));
    }, (requestSuccess) {
      emit(RegistrationCompleted());
    });
  }

  Future appLoginSetting(
      LoginSubmitted event, Emitter<NewUserAuthenticationState> emit) async {
    // get package info for version app
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // call API login
    final login = await postLogin(ParamLogin(
        id: event.id, pass: event.tel, apVersion: packageInfo.version));

    await login.fold(
      (responseFail) {
        Logging.log.warn(responseFail);
        emit(Error(
            messageCode: responseFail.msgCode,
            messageContent: responseFail.msgContent));
      },
      (responseSuccess) async {
        Logging.log.info('login success');

        if (responseSuccess.memberNum == '' || responseSuccess.userNum == 0) {
          emit(Error(
              messageCode: ErrorCode.MA010CE,
              messageContent: ErrorCode.MA010CE.tr()));
        } else {
          // Save access token
          var accessToken = responseSuccess.accessToken;
          var refreshToken = responseSuccess.refreshToken;

          // save user info
          await HelperFunction.instance.saveToken(accessToken, refreshToken);

          // set value login model
          await HelperFunction.instance.saveLoginModel(responseSuccess);

          // Emit call Agreement Page
          emit(LoginState(event.isNewUser, responseSuccess.memberNum,
              responseSuccess.userNum));
        }
      },
    );
  }
}
