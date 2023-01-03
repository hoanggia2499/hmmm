import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/secure_storage/share_preferences.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/util/version_utils/version_utils.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/login/domain/usecases/post_push_id.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../domain/usecases/check_user_available.dart';
import '../../domain/usecases/post_login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final PostLogin postLogin;
  final CheckUserAvailable checkUserAvailable;
  final PostPushId postPushId;

  String? _remoteConfigVersion;
  String? get getRemoteConfigVersion => this._remoteConfigVersion;
  set setRemoteConfigVersion(String? remoteConfigVersion) =>
      this._remoteConfigVersion = remoteConfigVersion;

  String? _storeVersion;
  String? get getStoreVersion => this._storeVersion;
  set setStoreVersion(String? storeVersion) =>
      this._storeVersion = storeVersion;

  String? _currentAppVersion;
  String? get getCurrentAppVersion => this._currentAppVersion;
  set setCurrentAppVersion(String? currentAppVersion) =>
      this._currentAppVersion = currentAppVersion;

  bool _isInitializeCheckUpdate = false;

  LoginBloc(this.postLogin, this.checkUserAvailable, this.postPushId)
      : super(Empty()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    // init
    on<LoginInit>(_onLoginInit);
    on<CheckUpdateEvent>(_onCheckUpdateApp);
  }

  Future _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(Loading());
    try {
      // get package info for version app
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // call API login
      final login = await postLogin(ParamLogin(
          id: int.tryParse(event.id) ?? 0,
          pass: event.pass,
          apVersion: packageInfo.version));

      await login.fold(
        (responseFail) async {
          Logging.log.info(responseFail);
          emit(Error(
              messageCode: responseFail.msgCode,
              messageContent: responseFail.msgContent));
        },
        (responseSuccess) async {
          Logging.log.info('login success');

          // Save access token
          var accessToken = responseSuccess.accessToken;
          var refreshToken = responseSuccess.refreshToken;

          // save user info
          await HelperFunction.instance.saveToken(accessToken, refreshToken);

          // set value login model
          await HelperFunction.instance.saveLoginModel(responseSuccess);

          // call API check user available
          final callAPICheckUser = await checkUserAvailable(ParamCheckUser(
              memberNum: responseSuccess.memberNum,
              userNum: responseSuccess.userNum));
          if ((responseSuccess.memberNum.isNotEmpty) &&
              (responseSuccess.memberNum != "")) {
            await callAPICheckUser.fold(
              (userFail) async {
                Logging.log.info('user fail: ' '${userFail.msgCode}');
                if (userFail.msgCode == ErrorCode.MA007SE &&
                    responseSuccess.memberNum != "") {
                  emit(UnavailableUser(
                      messageCode: userFail.msgCode,
                      messageContent: userFail.msgContent));
                } else {
                  emit(Error(
                      messageCode: userFail.msgCode,
                      messageContent: userFail.msgContent));
                }
              },
              (userSuccess) async {
                Logging.log.info('user available: $userSuccess');
                // Get is terms accpeted
                var isTermAccepted =
                    await UserSecureStorage.instance.getIsTermsAccepted() ??
                        '0';
                // call API post push id notification
                //type device: 1.Android 2.IOS
                var androidPushNotiId =
                    BaseStorage.instance.getStringValue('tokenPushId');
                final callAPIPostPushId = await postPushId(ParamPushId(
                    memberNum: responseSuccess.memberNum,
                    userNum: responseSuccess.userNum,
                    androidPushId: androidPushNotiId,
                    iOSPushId: '',
                    deviceType: Platform.isAndroid ? 1 : 2));
                await callAPIPostPushId.fold((fail) async {
                  Logging.log.info('result fail: ' '${fail.msgCode}');

                  emit(Error(
                      messageCode: fail.msgCode,
                      messageContent: fail.msgContent));
                }, (success) async {
                  Logging.log.info("androidPushNotiId token: ");
                  Logging.log.info(androidPushNotiId);
                  Logging.log.info("update id push notification success");
                });
                if (isTermAccepted.isNotEmpty && isTermAccepted != '1') {
                  emit(LoginSuccessful(
                      userStatus: userSuccess,
                      loginModel: responseSuccess,
                      id: event.id,
                      password: event.pass,
                      isTermsAccepted: isTermAccepted));
                } else {
                  emit(LoginInitState(
                      userStatus: userSuccess,
                      loginModel: responseSuccess,
                      id: event.id,
                      password: event.pass,
                      isTermsAccepted: isTermAccepted));
                }
              },
            );
          }
        },
      );
    } catch (ex) {
      Logging.log.info(ex.toString());
      emit(Error(
          messageCode: ErrorCode.MA013CE,
          messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future _onLoginInit(LoginInit event, Emitter<LoginState> emit) async {
    // Get saved user info
    var id = await UserSecureStorage.instance.getId();
    var password = await UserSecureStorage.instance.getPassword();
    var memberNum = await UserSecureStorage.instance.getMemberNum();
    var userNum = await UserSecureStorage.instance.getUserNum();
    // get Login Model
    var loginModel = await HelperFunction.instance.getLoginModel();
    // Get is terms accpeted
    var isTermAccepted =
        await UserSecureStorage.instance.getIsTermsAccepted() ?? '0';
    if (memberNum != "" && isTermAccepted != '0') {
      // call API check user available
      final callAPICheckUser = await checkUserAvailable(ParamCheckUser(
          memberNum: memberNum ?? '',
          userNum: userNum != null ? int.parse(userNum) : 0));
      await callAPICheckUser.fold(
        (userFail) async {
          Logging.log.info('user fail: ' '${userFail.msgCode}');
          if (userFail.msgCode == ErrorCode.MA007SE && memberNum != "") {
            emit(UnavailableUser(
                messageCode: userFail.msgCode,
                messageContent: userFail.msgContent));
          }
        },
        (userSuccess) async {
          Logging.log.info('user available: $userSuccess');
          // Get is terms accpeted
          if (isTermAccepted.isNotEmpty && isTermAccepted != '1') {
            emit(LoginSuccessful(
                userStatus: userSuccess,
                loginModel: loginModel,
                id: id,
                password: password,
                isTermsAccepted: isTermAccepted));
          } else {
            emit(LoginInitState(
                userStatus: userSuccess,
                loginModel: loginModel,
                id: id,
                password: password,
                isTermsAccepted: isTermAccepted));
          }
        },
      );
    }
  }

  Future _onCheckUpdateApp(
      CheckUpdateEvent event, Emitter<LoginState> emit) async {
    _currentAppVersion = await VersionUtils.instance.getAppVersionFromLocal();
    try {
      await _initCheckUpdate(event.context).then((isAvailable) async {
        if (isAvailable) {
          await _checkVersion(event.context,
                  event.eventAction == CheckUpdateEventAction.firstLaunchApp)
              .then((checkUpdateType) {
            if (checkUpdateType != null) {
              emit(Loading());
              emit(CheckedUpdateState(
                  eventAction: event.eventAction,
                  checkUpdateType: checkUpdateType));
            }

            return;
          });
          return;
        }
        return;
      });
      return;
    } catch (e) {
      Logging.log.error(e);
    }
  }

  Future<bool> _initCheckUpdate(BuildContext ctx) async {
    if (await InternetConnection.instance.isHasConnection()) {
      if (!_isInitializeCheckUpdate) {
        _remoteConfigVersion =
            await UserSecureStorage.instance.getVersionFirebase();
        _storeVersion = await UserSecureStorage.instance.getVersionStore();
      }
      return Future.value(true);
    } else {
      await VersionUtils.instance.showNoInternetDialog(ctx);
      return Future.value(false);
    }
  }

  Future<CheckUpdateType?> _checkVersion(
      BuildContext context, bool isFirstLaunch) async {
    if (_remoteConfigVersion != null) {
      var checkVersion = await VersionUtils.instance
          .checkVersion(remoteConfigVersion: _remoteConfigVersion!);
      var appName = await VersionUtils.instance.getAppName();

      // If checkVersion = 1 => force update, otherwise (=2) optional update
      if (checkVersion == 1) {
        await VersionUtils.instance
            .showForceUpdateDialog(context, _remoteConfigVersion!, appName);
        return CheckUpdateType.force;
      }

      if (isFirstLaunch) {
        if (checkVersion == 2) {
          var hasChecked = await VersionUtils.instance.showOptionalUpdateDialog(
              context, _remoteConfigVersion!, appName);
          _isInitializeCheckUpdate = hasChecked;
        }
        return CheckUpdateType.optional;
      }

      _isInitializeCheckUpdate = true;
      return null;
    }
    return null;
  }
}
