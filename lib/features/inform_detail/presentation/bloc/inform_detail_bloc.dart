import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/secure_storage/share_preferences.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_request.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../data/models/inform_detail_request.dart';
import '../../domain/usecases/move_to_car_detail.dart';
import '../../domain/usecases/update_status_inform.dart';

part 'inform_detail_event.dart';
part 'inform_detail_state.dart';

class InformDetailBloc extends Bloc<InformDetailEvent, InformDetailState> {
  final UpdateStatusInform getInformDetail;
  final MoveToCarDetail moveToCarDetail;

  InformDetailBloc(this.getInformDetail, this.moveToCarDetail)
      : super(Empty()) {
    on<GetInformDetailEvent>(_onUpdateStatusInform);
    on<GetCarSPEvent>(_onGetCarSp);
  }

  FutureOr<void> _onUpdateStatusInform(
      GetInformDetailEvent event, Emitter<InformDetailState> emit) async {
    emit(Loading());
    try {
      final getDetailInform = await getInformDetail(event.request);

      await getDetailInform.fold((responseFail) async {
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
        await BaseStorage.instance.setIntValue(
            Constants.NUMBER_OF_UNREAD_NOTIFICATIONS,
            (BaseStorage.instance
                    .getIntValue(Constants.NUMBER_OF_UNREAD_NOTIFICATIONS) -
                1));
        emit(Loaded());
        return true;
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  FutureOr<void> _onGetCarSp(
      GetCarSPEvent event, Emitter<InformDetailState> emit) async {
    emit(Loading());
    try {
      final getDetailInform = await moveToCarDetail(event.request);

      await getDetailInform.fold((responseFail) async {
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
        if (result != null) {
          emit(OnCarSPLinkAccessState(
            itemSearchModel: ItemSearchModel.convertFromCarSP(result),
          ));
        }

        return true;
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }
}
