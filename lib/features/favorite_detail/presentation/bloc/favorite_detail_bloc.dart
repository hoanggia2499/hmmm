import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/favorite_detail/domain/usecases/add_car_object.dart';
import 'package:mirukuru/features/favorite_detail/domain/usecases/delete_favorite_by_position.dart';
import 'package:mirukuru/features/favorite_detail/domain/usecases/get_car_object_list.dart';
import 'package:mirukuru/features/favorite_detail/domain/usecases/get_favorite_detail.dart';
import 'package:mirukuru/features/favorite_detail/presentation/bloc/favorite_detail_event.dart';
import 'package:mirukuru/features/favorite_detail/presentation/bloc/favorite_detail_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class FavoriteDetailBloc
    extends Bloc<FavoriteDetailEvent, FavoriteDetailState> {
  final GetFavoriteDetail getSeachDetail;
  final AddCarSeenFavorite addCarSeenFavorite;
  final DeleteFavoriteDetailByPosition deleteFavoriteDetailByPosition;
  final GetCarSeenFavoriteObjectList getCarSeenFavoriteObjectList;
  int countImageCurrent = 1;
  int countImageTotalEvent = 0;

  FavoriteDetailBloc(this.getSeachDetail, this.addCarSeenFavorite,
      this.deleteFavoriteDetailByPosition, this.getCarSeenFavoriteObjectList)
      : super(Empty()) {
    on<SearchCarEvent>(_onSearchDetailInit);
    on<CountImageEvent>(_onCountImageInit);
    on<CountImageTotalEvent>(_onCountImageTotalInit);
    on<SaveFavoriteToDBEvent>(_onSaveFavoriteToDb);
    on<DeleteFavoriteFromDBEvent>(_onDeleteFavoriteFromDB);
    on<AddCarLocalEvent>(_onAddCar);
  }

  Future _onSearchDetailInit(
      SearchCarEvent event, Emitter<FavoriteDetailState> emit) async {
    emit(Loading());
    try {
      // call API get agreement
      final callGetAgreement = await getSeachDetail(event.searchCarInputModel);

      await callGetAgreement.fold((responseFail) async {
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
        emit(Loaded(searchCarModelList: responseSuccess));
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onCountImageInit(
      CountImageEvent event, Emitter<FavoriteDetailState> emit) async {
    countImageCurrent = event.currentNumberOfChecked;
    emit(LoadedImage(imageCount: countImageCurrent.toString()));
  }

  Future _onCountImageTotalInit(
      CountImageTotalEvent event, Emitter<FavoriteDetailState> emit) async {
    countImageTotalEvent = event.currentNumberOfChecked;
    emit(LoadedImageTotal(imageCount: countImageTotalEvent.toString()));
  }

  Future<void> _onAddCar(
      AddCarLocalEvent event, Emitter<FavoriteDetailState> emit) async {
    try {
      final result = await addCarSeenFavorite.call(ParamAddCarRequests(
          item: event.item,
          tableName: event.tableName,
          questionNo: event.questionNo));

      await result.fold((responseFail) async {
        emit(Error(
            messageCode: responseFail.msgCode,
            messageContent: responseFail.msgContent));
        return false;
      }, (responseSuccess) async {
        Logging.log.info("Add car to local data success");
        return true;
      });
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<dynamic> onGetCarObjectList(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getCarSeenFavoriteObjectList
        .call(ParamGetCarListRequests(tableName: tableName, pic1Map: pic1Map));
    List<ItemSearchModel> listCarObject = [];
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      listCarObject = responseSuccess;
      return true;
    });
    return listCarObject;
  }

  Future<void> _onSaveFavoriteToDb(
      SaveFavoriteToDBEvent event, Emitter<FavoriteDetailState> emit) async {
    Logging.log.info("_onSaveFavoriteToDb");

    try {
      var favoriteList = await onGetCarObjectList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());

      var questionNo = event.item.corner + event.item.fullExhNum;

      bool alreadyExist = false;
      favoriteList.forEach((element) {
        if (element.questionNo == questionNo) {
          alreadyExist = true;
        }
      });

      if (!alreadyExist) {
        add(AddCarLocalEvent(
            event.item, Constants.FAVORITE_OBJECT_LIST_TABLE, questionNo));
      }
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<void> _onDeleteFavoriteFromDB(DeleteFavoriteFromDBEvent event,
      Emitter<FavoriteDetailState> emit) async {
    Logging.log.info("_onDeleteFavoriteFromDB");

    try {
      var questionNo = event.item.corner + event.item.fullExhNum;
      add(DeleteFavoriteByPositionEvent(
          Constants.FAVORITE_OBJECT_LIST_TABLE, questionNo));
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<void> removeCarSeen(
    ItemSearchModel item,
    String tableName,
    String questionNo,
    int index,
  ) async {
    add(RemoveCarEvent(
        item, Constants.ITEM_SEARCH_BEAN_TABLE, questionNo, index));
  }
}
