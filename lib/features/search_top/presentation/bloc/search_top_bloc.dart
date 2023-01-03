import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/core/util/firebase_message_helper.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/util/version_utils/version_utils.dart';
import 'package:mirukuru/features/app_bloc/app_bloc.dart';

import '../../../../core/util/error_code.dart';
import '../../../search_top/data/models/company_get_model.dart';
import '../../domain/usecases/company_get.dart';
import '../../domain/usecases/get_name.dart';
import '../../domain/usecases/get_number_of_unread.dart';

part 'search_top_event.dart';
part 'search_top_state.dart';

class SearchTopBloc extends Bloc<SearchTopEvent, SearchTopState> {
  final GetNumberOfUnread getNumberOfUnread;
  final GetName getName;
  final CompanyGet companyGet;

  SearchTopBloc(this.getNumberOfUnread, this.getName, this.companyGet)
      : super(Empty()) {
    on<GetNumberOfUnreadInit>(_onGetNumberOfUnreadInit);
    on<TopInit>(_onNameInit);
    on<CompanyGetInit>(_onCompanyGetInit);
    on<CheckUpdateEvent>(_onCheckUpdateApp);
  }

  Future _onNameInit(TopInit event, Emitter<SearchTopState> emit) async {
    if (event.isNameLoaded) {
      _getUnreadNotificationAndCheckPermission(event.context);
      return;
    }

    // call API GetName (API27)
    final callGetName = await getName(NoParamsExt());

    await callGetName.fold((responseFail) async {
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
      _getUnreadNotificationAndCheckPermission(event.context);
      BlocProvider.of<AppBloc>(event.context).isNameLoaded = true;
      return true;
    });
  }

  void _getUnreadNotificationAndCheckPermission(BuildContext context) async {
    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    var userNum = await UserSecureStorage.instance.getUserNum() ?? '';

    add(GetNumberOfUnreadInit(memberNum, int.parse(userNum.trim())));
    await checkAndRequestNotificationPermission(context);
  }

  Future _onGetNumberOfUnreadInit(
      GetNumberOfUnreadInit event, Emitter<SearchTopState> emit) async {
    try {
      final callGetNumberOfUnread = await getNumberOfUnread(
          ParamRequests(memberNum: event.memberNum, userNum: event.userNum));

      await callGetNumberOfUnread.fold((responseFail) async {
        Logging.log.error(responseFail);

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
        emit(LoadedGetNumberOfUnread(numberUnread: responseSuccess));
        return true;
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future _onCompanyGetInit(
      CompanyGetInit event, Emitter<SearchTopState> emit) async {
    try {
      // call API company get
      final callCompanyGet =
          await companyGet(ParamCompanyGet(memberNum: event.memberNum));

      await callCompanyGet.fold((responseFail) async {
        Logging.log.error(responseFail);

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
        // set value login model
        await HelperFunction.instance.saveTelCompany(responseSuccess.tel);

        emit(LoadedCompanyGet(companyGetModel: responseSuccess));
        return true;
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future _onCheckUpdateApp(
      CheckUpdateEvent event, Emitter<SearchTopState> emit) async {
    try {
      var remoteConfigVersion =
          await VersionUtils.instance.getFirebaseVersion();
      // var storeVersion = await Version_utils.getVersionStoreLatest();
      var checkVersion = await VersionUtils.instance
          .checkVersion(remoteConfigVersion: remoteConfigVersion);
      // var version = Version_utils.getVersionStoreLatest();
      var appName = VersionUtils.instance.getAppName();
      if (checkVersion == 1) {
        await VersionUtils.instance
            .showForceUpdateDialog(
                event.context, remoteConfigVersion, await appName)
            .whenComplete(() {
          emit(CheckedUpdateVersion());
        });
      }
      emit(CheckedUpdateVersion());
      return true;
    } catch (e) {
      Logging.log.error(e);
    }
  }

  Future<bool> checkAndRequestNotificationPermission(
      BuildContext context) async {
    final isGranted =
        await FirebaseMessageHelper.instance.checkPermission(context);
    if (!isGranted) {
      FirebaseMessageHelper.instance.requestPermission(context);
    }
    return true;
  }
}
