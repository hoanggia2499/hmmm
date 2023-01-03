import 'dart:collection';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';
import 'package:mirukuru/core/db/favorite_hive.dart';
import 'package:mirukuru/core/network/paginated_data_model.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/app_bloc/paginated_data_bloc_mixin.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';
import 'package:mirukuru/features/search_list/domain/usecases/add_car.dart';
import 'package:mirukuru/features/search_list/domain/usecases/add_search.dart';
import 'package:mirukuru/features/search_list/domain/usecases/delete_favorite_by_position.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_car_object_list.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_car_pic1.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_list_search_local.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_number_of_quotation_today.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_search_history.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_search_list.dart';
import 'package:mirukuru/features/search_list/domain/usecases/remove_car.dart';
import 'package:mirukuru/features/search_list/domain/usecases/update_search.dart';
import 'package:mirukuru/features/search_list/presentation/bloc/search_list_event.dart';
import 'package:mirukuru/features/search_list/presentation/bloc/search_list_state.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_favorite_access.dart';

import '../../../search_input/data/models/search_input_model.dart';
import '../../data/models/number_of_quotation_request.dart';

class SearchListBloc extends Bloc<SearchListEvent, SearchListState>
    with PaginatedDataBlocMixin<ItemSearchModel> {
  final GetSearchList getSearchList;
  final GetCarPic1 getCarPic1;
  final GetNumberOfQuotationToday getNumberOfQuotationToday;
  final GetFavoriteAccess getFavoriteAccess;
  final AddCar addCar;
  final DeleteFavoriteByPosition deleteFavoriteByPosition;
  final GetCarObjectList getCarObjectList;
  final RemoveCar removeCar;
  final GetListSearchLocal getListSearchLocal;
  final GetSearchHistory getSearchHistory;
  final UpdateSearch updateSearch;
  final AddSearch addSearch;
  late SearchListModel searchListModel;

  SearchListModel get getSearchListModelParam => this.searchListModel;
  set setSearchListModelParam(SearchListModel searchListModelParam) =>
      this.searchListModel = searchListModelParam;

  Map<String, String> pic1MapVar = new LinkedHashMap<String, String>();
  int currentNumberOfChecked = 0;
  List<ItemSearchModel> historyCarSeenList = [];
  SearchListBloc(
      this.getSearchList,
      this.getCarPic1,
      this.getNumberOfQuotationToday,
      this.getFavoriteAccess,
      this.addCar,
      this.deleteFavoriteByPosition,
      this.getCarObjectList,
      this.removeCar,
      this.getListSearchLocal,
      this.getSearchHistory,
      this.updateSearch,
      this.addSearch)
      : super(Empty()) {
    on<GetSearchListEvent>(_onSearchListInit);
    on<GetCarPic1Event>(_onGetCarPic1Init);
    on<RequestEstimateEvent>(_onGetNumberOfQuotationTodayInit);
    on<GetFavoriteAccessEvent>(_onGetFavoriteAccessInit);
    on<IncreaseRequestCountEvent>(_onIncreaseRequestCountInit);
    on<AddCarLocalEvent>(_onAddCar);
    on<DeleteFavoriteByPositionEvent>(_onDeleteFavoriteByPosition);
    on<RemoveCarEvent>(_onRemoveCar);
    on<SaveCarToDBEvent>(_onSaveCarToDb);
    on<InitFavoriteListEvent>(_onInitFavoriteList);
    on<SaveFavoriteToDBEvent>(_onSaveFavoriteToDb);
    on<DeleteFavoriteFromDBEvent>(_onDeleteFavoriteFromDB);
  }

  Future _onGetCarPic1Init(
      GetCarPic1Event event, Emitter<SearchListState> emit) async {
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

        // Create search list model
        searchListModel =
            await createSearchListModel(event.searchListModel, event.type);

        // Once call getCarPic1 successful, search car
        await _onSearchListInit(
            GetSearchListEvent(event.context, searchListModel, pic1Map), emit);
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
      Logging.log.warn("error image");
    }
  }

  Future _onSearchListInit(
      GetSearchListEvent event, Emitter<SearchListState> emit) async {
    emit(Loading());
    try {
      // call API get Search List
      if (event.searchListModel != searchListModel) {
        searchListModel = event.searchListModel;
      }

      if (!hasMoreData) {
        emit(Loaded(listItemSearchModel: []));
      }

      this.pageSize = 50;
      final callGetAgreement = await loadData(
          loadPageIndex: this.loadPageIndex, pageSize: this.pageSize);

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
        List<ItemSearchModel> itemSearchModelListNew = [];
        responseSuccess.data.forEach((element) {
          var imgUrlValue = HelperFunction.instance
              .getImageUrl(element.fullExhNum, element.corner, event.pic1Map);
          var priceModel = HelperFunction.instance.getPrice(element.price);

          var obj = ItemSearchModel(
              makerCode: element.makerCode,
              makerName: element.makerName,
              inspection: element.inspection,
              aaCount: element.aaCount,
              carGrade: element.carGrade,
              carLocation: element.carLocation,
              carMileage: element.carMileage,
              carModel: element.carModel,
              carName: element.carName,
              carVolume: element.carVolume,
              corner: element.corner,
              dTPointTotal: element.dTPointTotal,
              exhNum: element.exhNum,
              fuelName: element.fuelName,
              fullExhNum: element.fullExhNum,
              price: element.price,
              repairflag: element.repairflag,
              shiftName: element.shiftName,
              stars: element.stars,
              sysColorName: element.sysColorName,
              tel: element.tel,
              imageUrl: imgUrlValue,
              priceValue: priceModel.price,
              priceValue2: priceModel.price2,
              yen: priceModel.yen);

          itemSearchModelListNew.add(obj);
        });

        updatePaginatedDataParams(
            itemSearchModelListNew, responseSuccess.totalCount);
        emit(Loaded(listItemSearchModel: itemSearchModelListNew));
        return true;
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onGetNumberOfQuotationTodayInit(
      RequestEstimateEvent event, Emitter<SearchListState> emit) async {
    emit(Loading());
    try {
      var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
      var userNum = await UserSecureStorage.instance.getUserNum() ?? '';

      var requestModel = NumberOfQuotationRequestModel(
        memberNum: memberNum,
        userNum: int.tryParse(userNum) != null ? int.parse(userNum) : -1,
      );
      // call API get Number Of Quotation Today
      final callGetAgreement = await getNumberOfQuotationToday(requestModel);

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
        int resultInt = int.parse(responseSuccess);
        if (resultInt + currentNumberOfChecked > 5) {
          emit(Error(messageCode: '', messageContent: '5MA017CE'.tr()));
        } else {
          emit(RequestEstimate(
              numberOfQuotationToday: int.parse(responseSuccess)));
        }
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onGetFavoriteAccessInit(
      GetFavoriteAccessEvent event, Emitter<SearchListState> emit) async {
    emit(Loading());
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
        return false;
      }, (responseSuccess) async {
        emit(Empty());
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<SearchListModel> createSearchListModel(
      SearchInputModel searchInputParam, int type) async {
    // Set area
    if (searchInputParam.area == "WHOLE_COUNTRY".tr()) {
      searchInputParam.area = '';
    }
    var makerName = '';

    var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
    SearchListModel searchListModel = SearchListModel();
    searchListModel = SearchListModel(
        memberNum: memberNum,
        callCount: searchInputParam.callCount ?? 1,
        makerCode1: searchInputParam.makerCode1 ?? "",
        makerCode2: searchInputParam.makerCode2 ?? "",
        makerCode3: searchInputParam.makerCode3 ?? "",
        makerCode4: searchInputParam.makerCode4 ?? "",
        makerCode5: searchInputParam.makerCode5 ?? "",
        carName1: searchInputParam.carName1 ?? "",
        carName2: searchInputParam.carName2 ?? "",
        carName3: searchInputParam.carName3 ?? "",
        carName4: searchInputParam.carName4 ?? "",
        carName5: searchInputParam.carName5 ?? "",
        nenshiki1: searchInputParam.nenshiki1 ?? "",
        nenshiki2: searchInputParam.nenshiki2 ?? "",
        distance1: searchInputParam.distance1 ?? "",
        distance2: searchInputParam.distance2 ?? "",
        haikiryou1: searchInputParam.haikiryou1 ?? "",
        haikiryou2: searchInputParam.haikiryou2 ?? "",
        price1: searchInputParam.price1 ?? "",
        price2: searchInputParam.price2 ?? "",
        inspection: searchInputParam.inspection,
        mission: searchInputParam.mission,
        freeword: searchInputParam.freeword,
        color: searchInputParam.color,
        repair: searchInputParam.repair,
        area: searchInputParam.area,
        makerName: makerName);
    if (type == 0) {
      saveSearchHistoryToDb(searchListModel);
    }
    Logging.log.info(searchListModel);
    return searchListModel;
  }

  saveSearchHistoryToDb(SearchListModel searchListModel) async {
    Logging.log.info("save search history to db");

    var historySearchList = await onGetCarHistorySearch(
        Constants.SEARCH_INPUT_BEAN_TABLE, HashMap<String, String>());
    Logging.log.info("history search list length:");
    Logging.log.info(historySearchList.length);
    if (historySearchList.length > 30) {
      Logging.log.warn("over length");
      await onUpdateSearch(0, Constants.SEARCH_INPUT_BEAN_TABLE).whenComplete(
          () async => {
                await onAddSearch(
                    searchListModel, Constants.SEARCH_INPUT_BEAN_TABLE)
              });
    } else {
      await onAddSearch(searchListModel, Constants.SEARCH_INPUT_BEAN_TABLE);
    }
  }

  Future _onIncreaseRequestCountInit(
      IncreaseRequestCountEvent event, Emitter<SearchListState> emit) async {
    currentNumberOfChecked = event.currentNumberOfChecked;
  }

  @override
  Future<Either<ReponseErrorModel, PaginatedDataModel<ItemSearchModel>>>
      loadData({required int loadPageIndex, required int pageSize}) {
    return getSearchList(
        searchListModel.copyWith(pageSize: pageSize, pageIndex: loadPageIndex));
  }

  Future<void> _onAddCar(
      AddCarLocalEvent event, Emitter<SearchListState> emit) async {
    try {
      final result = await addCar.call(ParamAddCarRequests(
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
      Logging.log.warn("error add car to db");
    }
  }

  Future<void> _onDeleteFavoriteByPosition(DeleteFavoriteByPositionEvent event,
      Emitter<SearchListState> emit) async {
    try {
      final result = await deleteFavoriteByPosition.call(
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

  Future<void> _onRemoveCar(
      RemoveCarEvent event, Emitter<SearchListState> emit) async {
    try {
      final result = await removeCar.call(ParamRemoveCarListRequests(
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

  Future<dynamic> onGetCarHistorySearch(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getSearchHistory.call(
        ParamGetSearchHistoryRequests(tableName: tableName, pic1Map: pic1Map));
    List<SearchListModel> listSearchHistory = [];
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      listSearchHistory = responseSuccess;
      return true;
    });
    return listSearchHistory;
  }

  Future<void> onUpdateSearch(int index, String tableName) async {
    final result = await updateSearch
        .call(ParamUpdateSearchRequests(index: index, tableName: tableName));

    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      return true;
    });
  }

  Future<void> onAddSearch(SearchListModel element, String tableName) async {
    final result = await addSearch
        .call(ParamAddSearchRequests(element: element, tableName: tableName));

    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      return true;
    });
  }

  Future<List<ItemSearchModel>> onGetCarObjectList(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getCarObjectList
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

  Future<dynamic> onGetCarListSearchFromHiveDb(
    String tableName,
  ) async {
    final result = await getListSearchLocal
        .call(ParamGetCarSearchListRequests(tableName: tableName));
    List<CarSearchHive> listCarSearch = [];
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      listCarSearch = responseSuccess;
      return true;
    });
    return listCarSearch;
  }

  Future<dynamic> getCarListSearchFromHiveDb(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getCarObjectList
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

  Future<void> _onSaveCarToDb(
      SaveCarToDBEvent event, Emitter<SearchListState> emit) async {
    Logging.log.info("_onSaveCarToDb");

    try {
      var questionNo = event.item.corner + event.item.fullExhNum;
      int exhNum = event.item.exhNum;

      var listCarObject = await onGetCarObjectList(
          Constants.ITEM_SEARCH_BEAN_TABLE, HashMap<String, String>());
      int indexItem =
          listCarObject.indexWhere((element) => element.exhNum == exhNum);
      if (indexItem == -1) {
        add(AddCarLocalEvent(
            event.item, Constants.ITEM_SEARCH_BEAN_TABLE, questionNo));
      } else {
        await removeCarSeen(event.item, Constants.ITEM_SEARCH_BEAN_TABLE,
                questionNo, listCarObject.length >= 100 ? 0 : indexItem)
            .then((value) => {
                  add(AddCarLocalEvent(
                      event.item, Constants.ITEM_SEARCH_BEAN_TABLE, questionNo))
                });
      }
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
      Logging.log.warn("error save car to db");
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
      InitFavoriteListEvent event, Emitter<SearchListState> emit) async {
    Logging.log.info("_onInitFavoriteList");

    try {
      List<FavoriteHive> favoriteList = [];
      var favorites = await onGetCarObjectList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());
      favorites.forEach((element) {
        favoriteList.add(FavoriteHive(questionNo: element.questionNo));
      });
      emit(LoadedInitFavorite(listFavoriteHive: favoriteList));
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
      Logging.log.warn("error init favorite list");
    }
  }

  Future<void> _onSaveFavoriteToDb(
      SaveFavoriteToDBEvent event, Emitter<SearchListState> emit) async {
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
        add(InitFavoriteListEvent());
      }
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<void> _onDeleteFavoriteFromDB(
      DeleteFavoriteFromDBEvent event, Emitter<SearchListState> emit) async {
    Logging.log.info("_onDeleteFavoriteFromDB");

    try {
      var questionNo = event.item.corner + event.item.fullExhNum;
      add(DeleteFavoriteByPositionEvent(
          Constants.FAVORITE_OBJECT_LIST_TABLE, questionNo));
      add(InitFavoriteListEvent());
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }
}
