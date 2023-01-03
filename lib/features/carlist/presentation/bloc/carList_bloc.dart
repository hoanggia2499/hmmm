import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/carlist/domain/usecases/get_carList.dart';
import 'package:mirukuru/features/carlist/presentation/bloc/carList_event.dart';
import 'package:mirukuru/features/carlist/presentation/bloc/carList_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class CarListBloc extends Bloc<CarListEvent, CarListState> {
  final GetCarList getCarList;

  CarListBloc(
    this.getCarList,
  ) : super(Empty()) {
    on<GetCarListEvent>(_onGetCarListInit);
  }

  Future _onGetCarListInit(
      GetCarListEvent event, Emitter<CarListState> emit) async {
    emit(Loading());
    try {
      // call API Get Car List
      final callGetCarList = await getCarList(ParamCarListRequests(
          makerCode: event.makerCode, caller: event.caller));

      await callGetCarList.fold((responseFail) async {
        print(responseFail);

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
        emit(Loaded(listCarModel: responseSuccess));
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }
}
