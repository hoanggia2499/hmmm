import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/maker/domain/usecases/get_makerList.dart';
import 'package:mirukuru/features/maker/presentation/bloc/makerList_event.dart';
import 'package:mirukuru/features/maker/presentation/bloc/makerList_state.dart';

import '../../../../core/util/error_code.dart';

class MakerListBloc extends Bloc<MakerListEvent, MakerListState> {
  final GetMakerList getMakerList;

  MakerListBloc(this.getMakerList) : super(Empty()) {
    on<MakerListInit>(_onMakerListInit);
  }

  Future _onMakerListInit(
      MakerListInit event, Emitter<MakerListState> emit) async {
    emit(Loading());
    try {
      // call API get Maker List
      final callGetMakerList = await getMakerList(NoParamsExt());

      await callGetMakerList.fold((responseFail) async {
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
        emit(Loaded(makerEntity: responseSuccess));
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }
}
