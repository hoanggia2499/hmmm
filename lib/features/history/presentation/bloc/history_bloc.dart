import 'dart:async';
import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/db/favorite_hive.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/history/domain/usecases/add_car_object_list.dart';
import 'package:mirukuru/features/history/domain/usecases/delete_favorite.dart';
import 'package:mirukuru/features/history/domain/usecases/get_car_object_list.dart';
import 'package:mirukuru/features/history/domain/usecases/get_favorite_access.dart';
import 'package:mirukuru/features/history/domain/usecases/get_item_search_history_list.dart';
import 'package:mirukuru/features/history/domain/usecases/get_search_history_list.dart';
import 'package:mirukuru/features/history/domain/usecases/get_search_input_history_list.dart';
import 'package:mirukuru/features/history/domain/usecases/remove_car.dart';
import 'package:mirukuru/features/history/presentation/bloc/history_event.dart';
import 'package:mirukuru/features/history/presentation/bloc/history_state.dart';
import '../../../search_list/data/models/item_search_model.dart';
import '../../../search_list/data/models/search_list_model.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetItemSearchHistoryList getItemSearchHistoryList;
  final GetSearchInputHistoryList getSearchInputHistoryList;
  final GetFavoriteHistoryAccess getFavoriteAccess;
  final AddCarObjectHistory addCarObjectHistory;
  final DeleteFavoriteByPositionHistory deleteFavoriteByPositionHistory;
  final GetCarObjectListHistory getCarObjectListHistory;
  final GetSearchListHistory getSearchHistory;
  final RemoveCarHistory removeCarHistory;
  HistoryBloc(
      this.getItemSearchHistoryList,
      this.getSearchInputHistoryList,
      this.getFavoriteAccess,
      this.addCarObjectHistory,
      this.deleteFavoriteByPositionHistory,
      this.getCarObjectListHistory,
      this.getSearchHistory,
      this.removeCarHistory)
      : super(Empty()) {
    on<LoadItemSearchHistoryList>(_onLoadItemSearchHistoryList);
    on<LoadSearchInputHistoryList>(_onLoadSearchInputHistoryList);
    on<GetHistoryDataEvent>(_onGetHistoryDataEvent);
    on<GetFavoriteAccessEvent>(_onGetFavoriteAccessInit);
    on<AddCarLocalEvent>(_onAddCar);
    on<DeleteFavoriteByPositionEvent>(_onDeleteFavoriteByPosition);
    on<SaveCarToDBEvent>(_onSaveCarToDb);
    on<InitFavoriteListEvent>(_onInitFavoriteList);
    on<SaveFavoriteToDBEvent>(_onSaveFavoriteToDb);
    on<DeleteFavoriteFromDBEvent>(_onDeleteFavoriteFromDB);
    on<RemoveCarEvent>(_onRemoveCar);
  }

  Future _onLoadItemSearchHistoryList(
      LoadItemSearchHistoryList event, Emitter<HistoryState> emit) async {
    emit(Loading());
    try {
      await _loadItemSearchHistoryAgreement(emit);
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onLoadSearchInputHistoryList(
      LoadSearchInputHistoryList event, Emitter<HistoryState> emit) async {
    emit(Loading());
    try {
      await _loadSearchInputHistoryListAgreement(emit);
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  FutureOr<void> _onGetFavoriteAccessInit(
      GetFavoriteAccessEvent event, Emitter<HistoryState> emit) async {
    //emit(Loading());
    try {
      // call API Favorite Access
      final callGetFavoriteAccess =
          await getFavoriteAccess(event.favoriteAccessModel);

      await callGetFavoriteAccess.fold((responseFail) async {
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
        Logging.log.info("get favorite fail");
        return false;
      }, (responseSuccess) async {
        //emit(Empty());
        Logging.log.info("get favorite success");
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  FutureOr<void> _onGetHistoryDataEvent(
      GetHistoryDataEvent event, Emitter<HistoryState> emit) async {
    emit(Loading());
    try {
      var list1 = await _loadSearchInputHistoryListAgreement(emit);
      var list2 = await _loadItemSearchHistoryAgreement(emit);
      emit(Loaded(searchListModelList: list1, itemHistoryList: list2));
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<List<ItemSearchModel>> _loadItemSearchHistoryAgreement(
      Emitter<HistoryState> emit) async {
    List<ItemSearchModel> list = [];
    final loadItemSearchHistoryAgreement =
        await getItemSearchHistoryList.call(NoParamsExt());

    await loadItemSearchHistoryAgreement.fold((responseFail) async {
      Logging.log.warn(responseFail);

      emit(Error(
          messageCode: responseFail.msgCode,
          messageContent: responseFail.msgContent));
      return false;
    }, (responseSuccess) async {
      list = responseSuccess;
    });
    return list;
  }

  Future<List<SearchListModel>> _loadSearchInputHistoryListAgreement(
      Emitter<HistoryState> emit) async {
    List<SearchListModel> list = [];
    final loadSearchInputHistoryListAgreement =
        await getSearchInputHistoryList.call(NoParamsExt());

    await loadSearchInputHistoryListAgreement.fold((responseFail) async {
      Logging.log.warn(responseFail);

      emit(Error(
          messageCode: responseFail.msgCode,
          messageContent: responseFail.msgContent));
      return false;
    }, (responseSuccess) async {
      list = responseSuccess;
    });
    return list;
  }

  Future<void> _onAddCar(
      AddCarLocalEvent event, Emitter<HistoryState> emit) async {
    try {
      final result = await addCarObjectHistory.call(ParamAddCarRequests(
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

  Future<void> _onDeleteFavoriteByPosition(
      DeleteFavoriteByPositionEvent event, Emitter<HistoryState> emit) async {
    try {
      final result = await deleteFavoriteByPositionHistory.call(
          ParamDeleteFavoriteRequests(
              tableName: event.tableName, questionNo: event.questionNo));

      await result.fold((responseFail) async {
        emit(Error(
            messageCode: responseFail.msgCode,
            messageContent: responseFail.msgContent));
        return false;
      }, (responseSuccess) async {
        return true;
      });
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<List<ItemSearchModel>> onGetCarObjectList(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getCarObjectListHistory.call(
        ParamGetCarListHistoryRequests(tableName: tableName, pic1Map: pic1Map));
    List<ItemSearchModel> listCarObject = [];
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      listCarObject = responseSuccess;
      return true;
    });
    return listCarObject;
  }

  Future<void> _onSaveCarToDb(
      SaveCarToDBEvent event, Emitter<HistoryState> emit) async {
    Logging.log.info("_onSaveCarToDb");

    try {
      var questionNo = event.item.corner + event.item.fullExhNum;

      var listCarObject = await onGetCarObjectList(
          Constants.ITEM_SEARCH_BEAN_TABLE, HashMap<String, String>());

      int exhNum = event.item.exhNum;

      int indexItem =
          listCarObject.indexWhere((element) => element.exhNum == exhNum);
      if (indexItem == -1) {
        add(AddCarLocalEvent(
            event.item, Constants.ITEM_SEARCH_BEAN_TABLE, questionNo));
      } else {
        await removeCarSeen(event.item, Constants.ITEM_SEARCH_BEAN_TABLE,
                questionNo, listCarObject.length >= 100 ? 0 : indexItem)
            .then((value) => {
                  add(AddCarLocalEvent(listCarObject[indexItem],
                      Constants.ITEM_SEARCH_BEAN_TABLE, questionNo))
                });
      }
      add(GetHistoryDataEvent());
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

  Future<void> _onInitFavoriteList(
      InitFavoriteListEvent event, Emitter<HistoryState> emit) async {
    Logging.log.info("_onInitFavoriteList");

    try {
      List<FavoriteHive> favoriteList = [];
      add(GetHistoryDataEvent());
      List<ItemSearchModel> favorites = await onGetCarObjectList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());
      favorites.forEach((element) {
        favoriteList.add(FavoriteHive(questionNo: element.questionNo));
      });
      emit(LoadedInitFavorite(listFavoriteHive: favoriteList));
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<void> _onSaveFavoriteToDb(
      SaveFavoriteToDBEvent event, Emitter<HistoryState> emit) async {
    Logging.log.info("_onSaveFavoriteToDb");

    try {
      var questionNo = event.item.corner + event.item.fullExhNum;

      var listFavoriteObject = await onGetCarObjectList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());

      bool alreadyExist = false;
      listFavoriteObject.forEach((element) {
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

  Future<void> _onDeleteFavoriteFromDB(
      DeleteFavoriteFromDBEvent event, Emitter<HistoryState> emit) async {
    Logging.log.info("_onDeleteFavoriteFromDB");

    try {
      var questionNo = event.item.corner + event.item.fullExhNum;
      add(DeleteFavoriteByPositionEvent(
          Constants.FAVORITE_OBJECT_LIST_TABLE, questionNo));
      event.showFavorite();
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<void> _onRemoveCar(
      RemoveCarEvent event, Emitter<HistoryState> emit) async {
    try {
      final result = await removeCarHistory.call(ParamRemoveCarHistoryRequests(
          item: event.item,
          tableName: event.tableName,
          questionNo: event.questionNo,
          index: event.index));

      await result.fold((responseFail) async {
        emit(Error(
            messageCode: responseFail.msgCode,
            messageContent: responseFail.msgContent));
        return false;
      }, (responseSuccess) async {
        Logging.log.info("remove car from local data success");

        return true;
      });
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }
}
