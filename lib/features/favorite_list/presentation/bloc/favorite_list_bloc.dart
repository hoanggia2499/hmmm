import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/add_car_seen.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/delete_favorite_by_position.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/get_car_object_list.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/get_favorite_list.dart';
import 'package:mirukuru/features/favorite_list/domain/usecases/remove_car_seen.dart';
import 'package:mirukuru/features/favorite_list/presentation/bloc/favorite_list_event.dart';
import 'package:mirukuru/features/favorite_list/presentation/bloc/favorite_list_state.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/logger_util.dart';
import '../../../search_list/data/models/item_search_model.dart';
import '../../domain/usecases/get_car_pic1.dart';

class FavoriteListBloc extends Bloc<FavoriteListEvent, FavoriteListState> {
  final GetFavoriteList getFavoriteList;
  final GetCarPic1InFavorite getCarPic1;
  final GetCarFavoriteList getCarFavoriteList;
  final DeleteFavoriteListByPosition deleteFavoriteListByPosition;
  final AddCarSeenFavoriteList addCarSeenFavoriteList;
  final RemoveCarSeenFavoriteList removeCarSeenFavoriteList;
  Map<String, String> pic1MapVar = new LinkedHashMap<String, String>();
  List<ItemSearchModel> favoriteObjectList = [];

  FavoriteListBloc(
    this.getFavoriteList,
    this.getCarPic1,
    this.getCarFavoriteList,
    this.deleteFavoriteListByPosition,
    this.addCarSeenFavoriteList,
    this.removeCarSeenFavoriteList,
  ) : super(Empty()) {
    // on<FavoriteListInit>(_onFavoriteListInit);
    on<GetCarPic1Event>(_onGetCarPic1Init);
    on<AddCarLocalEvent>(_onAddCar);
    on<SaveCarToDBEvent>(_onSaveCarToDb);
    on<RemoveCarEvent>(_onRemoveCar);
    on<GetCarFavoriteEvent>(_onGetFavoriteList);
  }

  Future _onGetCarPic1Init(
      GetCarPic1Event event, Emitter<FavoriteListState> emit) async {
    emit(Loading());
    try {
      // call API Get Car Pic1
      final callGetAgreement = await getCarPic1(NoParamsExt());

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
        // Continue to get car detail
        Map<String, String> pic1Map = new LinkedHashMap<String, String>();
        responseSuccess.forEach((element) {
          pic1Map.putIfAbsent(element.corner, () => element.pic1);
        });
        pic1MapVar = pic1Map;
        add(GetCarFavoriteEvent(
            Constants.FAVORITE_OBJECT_LIST_TABLE, pic1MapVar));
        // Get favorite data
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<List<ItemSearchModel>> onGetCarObjectList(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getCarFavoriteList
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

  Future<void> _onGetFavoriteList(
      GetCarFavoriteEvent event, Emitter<FavoriteListState> emit) async {
    final result = await getCarFavoriteList.call(ParamGetCarListRequests(
        tableName: event.tableName, pic1Map: event.mapGet));

    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      emit(Loaded(favoriteObjectList: responseSuccess));
      return true;
    });
  }

  Future<void> onDeleteFavoriteByPositionList(
      String tableName, String questionNo) async {
    final result = await deleteFavoriteListByPosition.call(
        ParamDeleteFavoriteRequests(
            tableName: tableName, questionNo: questionNo));

    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      Logging.log.info("remove success");
      return true;
    });
  }

  Future<void> _onAddCar(
      AddCarLocalEvent event, Emitter<FavoriteListState> emit) async {
    try {
      final result = await addCarSeenFavoriteList.call(
          ParamAddCarSeenFavoriteListRequests(event.item,
              tableName: event.tableName, questionNo: event.questionNo));

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

  Future<void> _onRemoveCar(
      RemoveCarEvent event, Emitter<FavoriteListState> emit) async {
    try {
      final result = await removeCarSeenFavoriteList.call(
          ParamRemoveCarSeenFavoriteListRequests(event.tableName, event.index));

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

  Future<void> removeCarSeen(
    ItemSearchModel item,
    String tableName,
    String questionNo,
    int index,
  ) async {
    add(RemoveCarEvent(Constants.ITEM_SEARCH_BEAN_TABLE, index));
  }

  Future<void> _onSaveCarToDb(
      SaveCarToDBEvent event, Emitter<FavoriteListState> emit) async {
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
        Logging.log.warn("cannot get index item");
      } else {
        await removeCarSeen(event.item, Constants.ITEM_SEARCH_BEAN_TABLE,
                questionNo, listCarObject.length >= 100 ? 0 : indexItem)
            .then((value) => {
                  add(AddCarLocalEvent(listCarObject[indexItem],
                      Constants.ITEM_SEARCH_BEAN_TABLE, questionNo))
                });
      }
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }
}
