import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/util/helper_function.dart';
import '../../../login/data/models/login_model.dart';
import '../../../login/domain/usecases/post_login.dart';
import '../../domain/usecases/new_user_registration.dart';
import '../../domain/usecases/personal_register.dart';
import '../../domain/usecases/request_register.dart';

part 'user_registration_event.dart';
part 'user_registration_state.dart';

class UserRegistrationBloc
    extends Bloc<UserRegistrationEvent, UserRegistrationState> {
  final NewUserRegistration newUserRegistration;
  final PostLogin postLogin;
  final RequestRegister requestRegister;
  final PersonalRegister personalRegister;

  UserRegistrationBloc(this.newUserRegistration, this.postLogin,
      this.requestRegister, this.personalRegister)
      : super(Empty()) {
    on<UserRegistrationSubmitted>(_onUserRegistrationSubmitted);
    on<LoginSubmitted>(_callAPILogin);
    on<RequestRegisterSubmitted>(_callAPIRequestRegister);
    on<PersonalRegisterSubmitted>(_callAPIPersonalRegister);
  }

  Future _onUserRegistrationSubmitted(UserRegistrationSubmitted event,
      Emitter<UserRegistrationState> emit) async {
    emit(Loading());
    try {
      // call API RequestPretreatment
      final userRegistration = await newUserRegistration(
          Params(id: int.parse(event.id), tel: event.tel));

      await userRegistration.fold(
        (responseFail) async {
          emit(Error(
              messageCode: responseFail.msgCode,
              messageContent: responseFail.msgContent));
        },
        (responseSuccess) async {
          String dialogMessage = "以下の内容で登録します。よろしいですか？\n";
          if (responseSuccess.storeName.trim().isNotEmpty) {
            dialogMessage += "店名: " + responseSuccess.storeName + "\n";
          }

          dialogMessage += "お名前: " +
              event.name +
              "\nふりがな: " +
              event.nameKana +
              "\n携帯電話番号: " +
              event.tel;

          emit(DialogState(
              contentDialog: dialogMessage,
              personalAuthFlag: responseSuccess.personalAuthFlag,
              isExists: responseSuccess.isExists));
        },
      );
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, LoginModel>> appLoginSetting(
      LoginSubmitted event) async {
    // get package info for version app
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // call API login
    final login = await postLogin(ParamLogin(
        id: int.tryParse(event.id) ?? 0,
        pass: event.tel,
        apVersion: packageInfo.version));

    return login;
  }

  // process API Login
  Future _callAPILogin(
      LoginSubmitted event, Emitter<UserRegistrationState> emit) async {
    // call API login
    final login = await appLoginSetting(event);

    await login.fold((loginFail) async {
      emit(Error(
          messageCode: loginFail.msgCode,
          messageContent: loginFail.msgContent));
    }, (responseLogin) async {
      // Save access token
      var accessToken = responseLogin.accessToken;
      var refreshToken = responseLogin.refreshToken;

      // save token
      await HelperFunction.instance.saveToken(accessToken, refreshToken);

      // set value login model
      await HelperFunction.instance.saveLoginModel(responseLogin);

      emit(LoginState(
          event.isNewUser, responseLogin.memberNum, responseLogin.userNum));
    });
  }

  // call API47 RequestRegister
  Future _callAPIRequestRegister(RequestRegisterSubmitted event,
      Emitter<UserRegistrationState> emit) async {
    final userRequestRegister = await requestRegister(ParamRequests(
        id: int.parse(event.id),
        tel: event.tel,
        userName: event.name,
        userNameKana: event.nameKana));

    userRequestRegister.fold((requestFail) async {
      emit(Error(
          messageCode: requestFail.msgCode,
          messageContent: requestFail.msgContent));
    }, (requestSuccess) async {
      emit(RequestRegisterState());
    });
  }

  // call API45 PersonalRegister
  Future _callAPIPersonalRegister(PersonalRegisterSubmitted event,
      Emitter<UserRegistrationState> emit) async {
    final userPersonalRegister = await personalRegister(ParamPersonal(
        id: int.parse(event.id),
        tel: event.tel,
        userName: event.name,
        userNameKana: event.nameKana));

    userPersonalRegister.fold((requestFail) async {
      emit(Error(
          messageCode: requestFail.msgCode,
          messageContent: requestFail.msgContent));
    }, (requestSuccess) async {
      emit(PersonalRegisterState(
          memberNum: requestSuccess.memberNum,
          userNum: requestSuccess.userNum));
    });
  }
}
