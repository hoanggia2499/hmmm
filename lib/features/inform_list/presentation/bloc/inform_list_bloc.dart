import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/secure_storage/share_preferences.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_request.dart';

import '../../../../core/util/logger_util.dart';
import '../../data/models/inform_list_response.dart';
import '../../domain/usecases/get_inform_list.dart';

part 'inform_list_event.dart';
part 'inform_list_state.dart';

class InformListBloc extends Bloc<InformListEvent, InformListState> {
  final GetInformList getInformList;

  InformListBloc(this.getInformList) : super(Empty()) {
    on<GetInformListEvent>(_onGetInformList);
  }

  FutureOr<void> _onGetInformList(
      GetInformListEvent event, Emitter<InformListState> emit) async {
    emit(Loading());
    try {
      final getListInform = await getInformList(event.request);

      await getListInform.fold((responseFail) async {
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
      }, (result) async {
        if (result != null && result.isNotEmpty) {
          int numberOfUnreadNotification =
              result.where((value) => value.confirmDate == null).length;
          await BaseStorage.instance.setIntValue(
              Constants.NUMBER_OF_UNREAD_NOTIFICATIONS,
              numberOfUnreadNotification);
          emit(LoadedInformListState(listInform: result));
        } else {
          emit(LoadedInformListState(listInform: []));
        }
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }
}
