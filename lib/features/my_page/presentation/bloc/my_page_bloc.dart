import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_input_model.dart';
import 'package:mirukuru/features/my_page/domain/usecases/get_my_page_information.dart';
import 'package:mirukuru/features/my_page/domain/usecases/get_user_car_name_list.dart';
import 'package:mirukuru/features/my_page/domain/usecases/save_my_page_information.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_event.dart';
import 'package:mirukuru/features/my_page/presentation/bloc/my_page_state.dart';

import '../../data/models/user_car_name_request_model.dart';

class MyPageBloc extends Bloc<MyPageEvent, MyPageState> {
  final GetMyPageInformation getMyPageInformation;
  final SaveMyPageInformation saveMyPageInformation;
  final GetUserCarNameList getUserCarNameList;

  MyPageBloc(this.getMyPageInformation, this.saveMyPageInformation,
      this.getUserCarNameList)
      : super(Empty()) {
    on<LoadMyPageInformationEvent>(_onLoadMyPageInformation);
    on<SaveMyPageInformationEvent>(_onSaveMyPageInformation);
    on<GetUserCarNameListEvent>(_onLoadUserCarNameList);
  }

  Future _onLoadMyPageInformation(
      LoadMyPageInformationEvent event, Emitter<MyPageState> emit) async {
    emit(Loading());
    try {
      final callGetMyPageInfoAgreement =
          await getMyPageInformation.call(event.request);

      await callGetMyPageInfoAgreement.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }
        return false;
      }, (result) async {
        // Load UserCarNameList
        if (result == null) {
          emit(Empty());
        }
        add(GetUserCarNameListEvent(myPageModel: result!));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onSaveMyPageInformation(
      SaveMyPageInformationEvent event, Emitter<MyPageState> emit) async {
    emit(Loading());
    try {
      final callSaveMyPageInformation =
          await saveMyPageInformation.call(event.inputModel);

      callSaveMyPageInformation.fold((error) async {
        Logging.log.warn(error);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }

        return false;
      }, (result) async {
        emit(MyPageInfoUpdated("5MY001SI", "処理が実行されました。"));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onLoadUserCarNameList(
      GetUserCarNameListEvent event, Emitter<MyPageState> emit) async {
    emit(Loading());
    try {
      var userCarList = event.myPageModel.userCarList;
      var requestList =
          userCarList?.map((e) => UserCarNameRequestModel.from(e)).toList() ??
              List.empty(growable: true);

      final callLoadUserCarNameList =
          await getUserCarNameList.call(requestList);

      callLoadUserCarNameList.fold((error) async {
        Logging.log.warn(error.toString());

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }
        return false;
      }, (result) async {
        var myPageInputModel = MyPageInputModel.convertFrom(event.myPageModel);

        if (result != null) {
          for (int i = 0; i < userCarList!.length; i++) {
            userCarList[i].userCarNameModel = result[i];
          }
        }
        emit(MyPageInfoLoaded(
            myPageInputModel.copyWith(userCarList: userCarList)));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }
}
