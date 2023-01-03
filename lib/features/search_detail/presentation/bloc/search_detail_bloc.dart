import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/search_detail/domain/usecases/add_favorite.dart';
import 'package:mirukuru/features/search_detail/domain/usecases/delete_favorite.dart';
import 'package:mirukuru/features/search_detail/domain/usecases/get_favorite_access.dart';
import 'package:mirukuru/features/search_detail/domain/usecases/get_favorite_list.dart';
import 'package:mirukuru/features/search_detail/domain/usecases/get_search_detail.dart';
import 'package:mirukuru/features/search_detail/presentation/bloc/search_detail_event.dart';
import 'package:mirukuru/features/search_detail/presentation/bloc/search_detail_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class SearchDetailBloc extends Bloc<SearchDetailEvent, SearchDetailState> {
  final GetSeachDetail getSeachDetail;
  final AddFavoriteSearchDetail addFavoriteSearchDetail;
  final DeleteFavoriteSearchDetail deleteFavoriteSearchDetail;
  final GetFavoriteListSeachDetail getFavoriteListSeachDetail;
  final GetFavoriteSearchDetailAccess getFavoriteSearchDetailAccess;
  int countImageCurrent = 1;
  int countImageTotalEvent = 0;

  SearchDetailBloc(
      this.getSeachDetail,
      this.addFavoriteSearchDetail,
      this.deleteFavoriteSearchDetail,
      this.getFavoriteListSeachDetail,
      this.getFavoriteSearchDetailAccess)
      : super(Empty()) {
    on<SearchCarEvent>(_onSearchDetailInit);
    on<CountImageEvent>(_onCountImageInit);
    on<CountImageTotalEvent>(_onCountImageTotalInit);
    on<SaveFavoriteToDBEvent>(_onSaveFavoriteToDB);
    on<DeleteFavoriteFromDBEvent>(_onDeleteFavoriteFromDB);
    on<GetFavoriteAccessEvent>(_onGetFavoriteAccessInit);
  }

  Future _onSearchDetailInit(
      SearchCarEvent event, Emitter<SearchDetailState> emit) async {
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
      CountImageEvent event, Emitter<SearchDetailState> emit) async {
    countImageCurrent = event.currentNumberOfChecked;
    emit(LoadedImage(imageCount: countImageCurrent.toString()));
  }

  Future _onCountImageTotalInit(
      CountImageTotalEvent event, Emitter<SearchDetailState> emit) async {
    countImageTotalEvent = event.currentNumberOfChecked;
    emit(LoadedImageTotal(imageCount: countImageTotalEvent.toString()));
  }

  Future<void> onAddFavorite(
      ItemSearchModel item, String tableName, String questionNo) async {
    try {
      final result = await addFavoriteSearchDetail.call(
          ParamAddFavoriteSearchDetailRequests(item,
              tableName: tableName, questionNo: questionNo));

      await result.fold((responseFail) async {
        return false;
      }, (responseSuccess) async {
        Logging.log.info("Add favorite to local data success search detail");
        return true;
      });
    } catch (ex) {
      Logging.log.info('ERROR_HAPPENDED'.tr());
    }
  }

  Future<List<ItemSearchModel>> onGetFavoriteObjectList(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getFavoriteListSeachDetail.call(
        ParamGetFavoriteListSeachDetailRequests(
            tableName: tableName, pic1Map: pic1Map));
    List<ItemSearchModel> listCarObject = [];
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      listCarObject = responseSuccess;
      return true;
    });
    return listCarObject;
  }

  Future<void> onDeleteFavoriteByPositionList(
      String tableName, String questionNo) async {
    final result = await deleteFavoriteSearchDetail.call(
        ParamDeleteFavoriteSearchDetailRequests(
            tableName: tableName, questionNo: questionNo));

    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      Logging.log.info("remove success");
      return true;
    });
  }

  Future<void> _onSaveFavoriteToDB(
      SaveFavoriteToDBEvent event, Emitter<SearchDetailState> emit) async {
    try {
      var favoriteList = await onGetFavoriteObjectList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());

      var questionNo =
          event.itemSearchModel.corner + event.itemSearchModel.fullExhNum;

      bool alreadyExist = false;
      favoriteList.forEach((element) {
        if (element.questionNo == questionNo) {
          alreadyExist = true;
        }
      });

      if (!alreadyExist) {
        await onAddFavorite(event.itemSearchModel,
            Constants.FAVORITE_OBJECT_LIST_TABLE, questionNo);
      }
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<void> _onDeleteFavoriteFromDB(
      DeleteFavoriteFromDBEvent event, Emitter<SearchDetailState> emit) async {
    try {
      var questionNo =
          event.itemSearchModel.corner + event.itemSearchModel.fullExhNum;

      await onDeleteFavoriteByPositionList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, questionNo);
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  FutureOr<void> _onGetFavoriteAccessInit(
      GetFavoriteAccessEvent event, Emitter<SearchDetailState> emit) async {
    //emit(Loading());
    try {
      // call API Favorite Access
      final callGetFavoriteAccess =
          await getFavoriteSearchDetailAccess(event.favoriteAccessModel);

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
}
