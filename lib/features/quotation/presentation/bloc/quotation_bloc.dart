import 'dart:async';
import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/features/quotation/domain/usecases/add_favorite.dart';
import 'package:mirukuru/features/quotation/domain/usecases/delete_favorite.dart';
import 'package:mirukuru/features/quotation/domain/usecases/get_favorite_list.dart';
import 'package:mirukuru/features/quotation/domain/usecases/make_an_inquiry.dart';
import 'package:mirukuru/features/quotation/presentation/bloc/quotation_event.dart';
import 'package:mirukuru/features/quotation/presentation/bloc/quotation_state.dart';
import 'package:mirukuru/features/quotation/presentation/models/inquiry_type_enum.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_number_of_quotation_today.dart';

import '../../../../core/secure_storage/user_secure_storage.dart';
import '../../../search_list/data/models/number_of_quotation_request.dart';
import '../../domain/usecases/get_car_model.dart';

class QuotationBloc extends Bloc<QuotationEvent, QuotationState> {
  final MakeAnInquiry makeAnInquiry;
  final GetNumberOfQuotationToday getNumberOfQuotationToday;
  final GetCarDetail getCarDetail; // get ドア数,ハンドル,車歴,冷房,車台番号下3桁
  final AddFavoriteQuotation addFavoriteQuotation;
  final DeleteFavoriteQuotation deleteFavoriteQuotation;
  final GetFavoriteListQuotation getFavoriteListQuotation;
  QuotationBloc(
      this.makeAnInquiry,
      this.getNumberOfQuotationToday,
      this.getCarDetail,
      this.addFavoriteQuotation,
      this.deleteFavoriteQuotation,
      this.getFavoriteListQuotation)
      : super(Empty()) {
    on<MakeAnInquiryEvent>(_onCategorizedAnInquiry);
    on<InitCarModelEvent>(_onInitCarModel);
    on<SaveFavoriteToDBEvent>(_onSaveFavoriteToDB);
    on<DeleteFavoriteFromDBEvent>(_onDeleteFavoriteFromDB);
  }

  Future _onCategorizedAnInquiry(
      MakeAnInquiryEvent event, Emitter<QuotationState> emit) async {
    if (event.inquiryRequestModel.id ==
        InquiryTypeEnum.REQUEST_FOR_QUOTATION.index + 1) {
      await _onRequestQuotation(event, emit);
    } else {
      await _onMakeAnInquiry(event, emit);
    }
  }

  Future _onMakeAnInquiry(
      MakeAnInquiryEvent event, Emitter<QuotationState> emit) async {
    emit(Loading());
    try {
      final callMakeAnInquiryAgreement =
          await makeAnInquiry.call(event.inquiryRequestModel);

      await callMakeAnInquiryAgreement.fold((responseFail) async {
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
        emit(InquirySentState());
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onRequestQuotation(
      MakeAnInquiryEvent event, Emitter<QuotationState> emit) async {
    emit(Loading());
    try {
      var memberNum = await UserSecureStorage.instance.getMemberNum() ?? '';
      var userNum = await UserSecureStorage.instance.getUserNum() ?? '';

      var requestModel = NumberOfQuotationRequestModel(
        memberNum: memberNum,
        userNum: int.tryParse(userNum) != null ? int.parse(userNum) : -1,
      );

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
        if (resultInt < 5) {
          await _onMakeAnInquiry(event, emit);
        } else {
          emit(Error(messageCode: "", messageContent: "5MA017CE".tr()));
        }
      });
    } catch (ex) {
      Logging.log.error(ex);
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  FutureOr<void> _onInitCarModel(
      InitCarModelEvent event, Emitter<QuotationState> emit) async {
    emit(Loading());
    try {
      // call API get agreement
      final callGetAgreement = await getCarDetail(event.searchCarInputModel);

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

  Future<void> onAddFavorite(
      ItemSearchModel item, String tableName, String questionNo) async {
    try {
      final result = await addFavoriteQuotation.call(
          ParamAddFavoriteQuotationRequests(item,
              tableName: tableName, questionNo: questionNo));

      await result.fold((responseFail) async {
        return false;
      }, (responseSuccess) async {
        Logging.log.info("Add favorite to local data success quotation");
        return true;
      });
    } catch (ex) {
      Logging.log.info('ERROR_HAPPENDED'.tr());
    }
  }

  Future<List<ItemSearchModel>> onGetFavoriteObjectList(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getFavoriteListQuotation.call(
        ParamGetFavoriteListQuotationRequests(
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
    final result = await deleteFavoriteQuotation.call(
        ParamDeleteFavoriteQuotationRequests(
            tableName: tableName, questionNo: questionNo));

    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      Logging.log.info("remove success");
      return true;
    });
  }

  Future<void> _onSaveFavoriteToDB(
      SaveFavoriteToDBEvent event, Emitter<QuotationState> emit) async {
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
      DeleteFavoriteFromDBEvent event, Emitter<QuotationState> emit) async {
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
}
