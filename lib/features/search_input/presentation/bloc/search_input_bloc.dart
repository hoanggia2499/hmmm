import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/features/search_input/domain/usecases/get_car_list_search.dart';
import 'package:mirukuru/features/search_input/domain/usecases/get_name_bean.dart';
part 'search_input_event.dart';
part 'search_input_state.dart';

enum TypeUpdate {
  NENSHIKI,
  DISTANCE,
  PRICE,
  HAIKIRYOU,
}

class SearchInputBloc extends Bloc<SearchInputEvent, SearchInputState> {
  final GetCarListSearchFavorite getCarListSearchFavorite;
  final GetNameBeanFavorite getNameBeanFavorite;
  SearchInputBloc(this.getCarListSearchFavorite, this.getNameBeanFavorite)
      : super(Empty()) {
    on<UpdateValueEvent>(_updateValue);
  }

  void _updateValue(UpdateValueEvent event, Emitter<SearchInputState> emit) {
    emit(Loading());
    switch (event.type) {
      case TypeUpdate.NENSHIKI:
        guard(event, emit,
            enforcement:
                UpdateNenshikiState(event.firstValue, event.secondValue),
            infringe: AlertState('年式の条件が不正です。\n条件を見直してください。'));
        break;
      case TypeUpdate.DISTANCE:
        guard(event, emit,
            enforcement:
                UpdateDistanceState(event.firstValue, event.secondValue),
            infringe: AlertState('走行距離の条件が不正です。\n条件を見直してください。'));
        break;
      case TypeUpdate.PRICE:
        guard(event, emit,
            enforcement: UpdatePriceState(event.firstValue, event.secondValue),
            infringe: AlertState('価格帯の条件が不正です。\n条件を見直してください。'));
        break;
      case TypeUpdate.HAIKIRYOU:
        guard(event, emit,
            enforcement:
                UpdateHaikiryouState(event.firstValue, event.secondValue),
            infringe: AlertState('排気量の条件が不正です。\n条件を見直してください。'));
        break;
    }
  }

  void guard(UpdateValueEvent event, Emitter<SearchInputState> emit,
      {required SearchInputState enforcement,
      required SearchInputState infringe}) {
    if (event.firstValue != null &&
        event.secondValue != null &&
        event.firstValue!.isNotEmpty &&
        event.secondValue!.isNotEmpty) {
      var value1 = int.parse(event.firstValue ?? '0');
      var value2 = int.parse(event.secondValue ?? '0');
      if (value1 <= value2) {
        emit(enforcement);
      } else {
        emit(infringe);
      }
    } else if (event.firstValue == null ||
        event.secondValue == null ||
        event.firstValue!.isEmpty ||
        event.secondValue!.isEmpty) {
      emit(enforcement);
    }
  }

  Future<List<CarSearchHive>> onGetCarListSearchFavorite(
      String tableName) async {
    final result = await getCarListSearchFavorite
        .call(ParamCarListSearchFavoriteRequests(tableName: tableName));
    List<CarSearchHive> listCarSearch = [];
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      listCarSearch = responseSuccess;

      return true;
    });
    return listCarSearch;
  }

  Future<List<NameBeanHive>> onGetNameBeanFavorite(String tableName) async {
    final result = await getNameBeanFavorite
        .call(ParamNameBeanRequests(tableName: tableName));
    List<NameBeanHive> listNameBeanHive = [];
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      listNameBeanHive = responseSuccess;
      return true;
    });
    return listNameBeanHive;
  }
}
