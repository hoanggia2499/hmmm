import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/store_information/domain/usecases/get_store_information.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_event.dart';
import 'package:mirukuru/features/store_information/presentation/bloc/store_state.dart';

import '../../../../core/util/logger_util.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final GetStoreInformation getStoreInformation;

  StoreBloc(this.getStoreInformation) : super(Empty()) {
    on<LoadStoreInformationEvent>(_onLoadStoreInformation);
  }

  FutureOr<void> _onLoadStoreInformation(
      LoadStoreInformationEvent event, Emitter<StoreState> emit) async {
    emit(Loading());
    try {
      final callGetStoreInfoAgreement =
          await getStoreInformation.call(event.memberNum);

      await callGetStoreInfoAgreement.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }
        return false;
      }, (result) async {
        if (result == null) {
          emit(Empty());
        }
        emit(Loaded(storeInformation: result));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }
}
