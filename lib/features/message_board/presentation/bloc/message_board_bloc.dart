import 'dart:async';
import 'dart:collection';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/db/core_db.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/image_util.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/show_and_pickup_photo_view.dart';
import 'package:mirukuru/features/message_board/domain/usecases/add_favorite.dart';
import 'package:mirukuru/features/message_board/domain/usecases/delete_favorite.dart';
import 'package:mirukuru/features/message_board/domain/usecases/delete_photo.dart';
import 'package:mirukuru/features/message_board/domain/usecases/get_color_name.dart';
import 'package:mirukuru/features/message_board/domain/usecases/get_favorite_list.dart';
import 'package:mirukuru/features/message_board/domain/usecases/get_message_board.dart';
import 'package:mirukuru/features/message_board/domain/usecases/send_new_comment.dart';
import 'package:mirukuru/features/message_board/domain/usecases/upload_photo_use_case.dart';
import 'package:mirukuru/features/message_board/presentation/bloc/message_board_event.dart';
import 'package:mirukuru/features/message_board/presentation/bloc/message_board_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/number_of_quotation_request.dart';
import 'package:mirukuru/features/search_list/domain/usecases/get_number_of_quotation_today.dart';

class MessageBoardBloc extends Bloc<MessageBoardEvent, MessageBoardState> {
  final GetMessageBoard getMessageBoard;
  final GetNumberOfQuotationToday getNumberOfQuotationToday;
  final SendNewComment sendNewComment;
  final DeletePhoto deletePhoto;
  final UploadPhotoUseCase uploadPhoto;
  final AddFavoriteMessageBoard addFavoriteMessageBoard;
  final DeleteFavoriteMessageBoard deleteFavoriteMessageBoard;
  final GetFavoriteListLocalMessageBoard getFavoriteListLocalMessageBoard;
  final GetColorName getColorName;
  bool _isFavorite = false;
  bool get isFavorite => this._isFavorite;
  set isFavorite(bool value) => this._isFavorite = value;

  List<FavoriteHive> _favorites = [];

  int _numberOfQuotationToday = -1;

  List<PhotoData> _deletePhotoList = [];
  List<PhotoData> _uploadPhotoList = [];
  List<PhotoData> _existingPhotoList = [];

  List<PhotoData> get deletePhotoList => this._deletePhotoList;
  set deletePhotoList(List<PhotoData> value) {
    this._deletePhotoList = value;
    value.forEach((deletePhoto) {
      this._existingPhotoList.removeWhere((element) => element == deletePhoto);
    });
    add(MessageBoardUpdatePhoto());
  }

  List<PhotoData> get uploadPhotoList => this._uploadPhotoList;
  set uploadPhotoList(List<PhotoData> value) {
    this._uploadPhotoList = value;
    value.forEach((element) {
      if (!_existingPhotoList.contains(element))
        this._existingPhotoList.add(element);
    });
    add(MessageBoardUpdatePhoto());
  }

  List<PhotoData> get existingPhotoList => this._existingPhotoList;
  set existingPhotoList(List<PhotoData> value) {
    this._existingPhotoList.clear();
    this._existingPhotoList.addAll(value);
    add(MessageBoardUpdatePhoto());
  }

  MessageBoardBloc(
      this.getMessageBoard,
      this.getNumberOfQuotationToday,
      this.sendNewComment,
      this.deletePhoto,
      this.uploadPhoto,
      this.addFavoriteMessageBoard,
      this.deleteFavoriteMessageBoard,
      this.getFavoriteListLocalMessageBoard,
      this.getColorName)
      : super(Empty()) {
    on<MessageBoardInit>(_onMessageBoardDetailInit);
    on<MessageBoardFavoriteClicked>(_onFavoriteClicked);
    on<MessageBoardSendComment>(_onCheckAndSendComment);
    on<MessageBoardDeletePhoto>(_onDeletePhoto);
    on<MessageBoardUploadPhoto>(_onUploadPhoto);
    on<MessageBoardUpdatePhoto>((event, emit) {
      emit(Loading());
      emit(UpdatedPhotos());
    });
  }

  Future _onMessageBoardDetailInit(
      MessageBoardInit event, Emitter<MessageBoardState> emit) async {
    emit(Loading());
    try {
      final callGetQuotationDetailAgreement =
          await getMessageBoard.call(event.request);

      await callGetQuotationDetailAgreement.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(
              messageCode: error.msgCode, messageContent: error.msgContent));
        } else {
          emit(Error(
              messageCode: error.msgCode, messageContent: error.msgContent));
        }
        return false;
      }, (result) async {
        if (result.asnetCarDetailModel != null) {
          String questionNo =
              "${result.asnetCarDetailModel?.corner}${result.asnetCarDetailModel?.fullExhNum}";
          await _checkFavorite(questionNo);
        } else if (result.ownCarDetailModel != null) {
          String colorName =
              await onGetColorName(result.ownCarDetailModel?.colorName ?? "");
          Logging.log.info("color name: $colorName");
          result.ownCarDetailModel =
              result.ownCarDetailModel!.copyWith(colorName: colorName);
        } else if (result.ownCarDetailModel == null) {
          emit(CarRemoved(
              messageCode: '', messageContent: "UNABLE_TO_RETRIEVE_DATA".tr()));
          return true;
        }

        if (result.images != null && result.images!.isNotEmpty) {
          result.images!.retainWhere((element) =>
              ImageUtil.instance.isAcceptExtension(element.split(".").last));
        }

        emit(Loaded(messageBoardDetailModel: result));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  FutureOr<void> _checkFavorite(String questionNo) {
    _initFavoriteList().whenComplete(
      () {
        var isExist =
            _favorites.any((element) => element.questionNo == questionNo);
        isFavorite = isExist;
      },
    );
  }

  Future _onFavoriteClicked(MessageBoardFavoriteClicked event,
      Emitter<MessageBoardState> emit) async {
    emit(Loading());
    await _initFavoriteList().whenComplete(() async {
      await _updateFavoriteList(event.itemSearchModel)
          .whenComplete(() => emit(FavoriteUpdated(isChecked: isFavorite)));
    });
  }

  Future<void> _initFavoriteList() async {
    if (_favorites.isEmpty) {
      var favoriteObjectList = await onGetFavoriteObjectList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, HashMap<String, String>());

      favoriteObjectList.forEach((element) {
        _favorites.add(FavoriteHive(questionNo: element.questionNo));
      });
    }
  }

  Future _updateFavoriteList(ItemSearchModel itemSearchModel) {
    isFavorite = !isFavorite;

    if (isFavorite) {
      return onAddFavorite(itemSearchModel,
          Constants.FAVORITE_OBJECT_LIST_TABLE, itemSearchModel.questionNo);
    } else {
      return onDeleteFavoriteByPositionList(
          Constants.FAVORITE_OBJECT_LIST_TABLE, itemSearchModel.questionNo);
    }
  }

  Future _onCheckAndSendComment(
      MessageBoardSendComment event, Emitter<MessageBoardState> emit) async {
    try {
      if (_numberOfQuotationToday < 0) {
        await _getNumberOfQuotationToday(event, emit).whenComplete(() async {
          if (_numberOfQuotationToday >= 5) {
            emit(Error(messageCode: "", messageContent: "5MA017CE".tr()));
          } else {
            await _onSendComment(event, emit);
          }
        });
      } else if (_numberOfQuotationToday >= 0 && _numberOfQuotationToday < 5) {
        await _onSendComment(event, emit);
      } else {
        emit(Loading());
        emit(Error(messageCode: "", messageContent: "5MA017CE".tr()));
      }
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onSendComment(
      MessageBoardSendComment event, Emitter<MessageBoardState> emit) async {
    emit(Loading());
    try {
      final createNewCommentAgreement =
          await sendNewComment.call(event.request);

      await createNewCommentAgreement.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(
              messageCode: error.msgCode, messageContent: error.msgContent));
        } else {
          emit(Error(
              messageCode: error.msgCode, messageContent: error.msgContent));
        }
        return false;
      }, (result) async {
        if (event.deleteRemotePhotoRequest != null &&
            event.deleteRemotePhotoRequest!.isNotEmpty) {
          add(MessageBoardDeletePhoto(
              event.deleteRemotePhotoRequest!, event.uploadPhotoRequestModel));
        } else {
          if (event.uploadPhotoRequestModel != null) {
            add(MessageBoardUploadPhoto(event.uploadPhotoRequestModel!));
          } else {
            emit(SentComment());
            return true;
          }
        }
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _getNumberOfQuotationToday(
      MessageBoardSendComment event, Emitter<MessageBoardState> emit) async {
    emit(Loading());
    try {
      final numberOfQuotationTodayAgreement =
          await getNumberOfQuotationToday.call(NumberOfQuotationRequestModel(
              memberNum: event.request.memberNum,
              userNum: event.request.userNum));

      await numberOfQuotationTodayAgreement.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(
              messageCode: error.msgCode, messageContent: error.msgContent));
        } else {
          emit(Error(
              messageCode: error.msgCode, messageContent: error.msgContent));
        }
        return false;
      }, (result) async {
        _numberOfQuotationToday = int.tryParse(result) ?? -1;
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onDeletePhoto(
      MessageBoardDeletePhoto event, Emitter<MessageBoardState> emit) async {
    emit(Loading());
    try {
      var deletePhotoAgreement = await deletePhoto.call(event.request);

      await deletePhotoAgreement.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(
              messageCode: error.msgCode, messageContent: error.msgContent));
        } else {
          emit(Error(
              messageCode: error.msgCode, messageContent: error.msgContent));
        }
        return false;
      }, (result) async {
        if (event.uploadPhotoRequestModel != null) {
          add(MessageBoardUploadPhoto(event.uploadPhotoRequestModel!));
        } else {
          emit(SentComment());
          return true;
        }
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onUploadPhoto(
      MessageBoardUploadPhoto event, Emitter<MessageBoardState> emit) async {
    try {
      var uploadingPhoto = await uploadPhoto.call(event.request);
      await uploadingPhoto.fold((error) async {
        Logging.log.warn(error.msgCode);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(
              messageCode: error.msgCode, messageContent: error.msgContent));
        } else {
          emit(Error(
              messageCode: error.msgCode, messageContent: error.msgContent));
        }
        return false;
      }, (result) async {
        emit(SentComment());
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future<void> onAddFavorite(
      ItemSearchModel item, String tableName, String questionNo) async {
    try {
      final result = await addFavoriteMessageBoard.call(
          ParamAddFavoriteListRequests(item,
              tableName: tableName, questionNo: questionNo));

      await result.fold((responseFail) async {
        return false;
      }, (responseSuccess) async {
        Logging.log.info("Add favorite to local data success");
        return true;
      });
    } catch (ex) {
      Logging.log.info('ERROR_HAPPENDED'.tr());
    }
  }

  Future<List<ItemSearchModel>> onGetFavoriteObjectList(
      String tableName, Map<String, String> pic1Map) async {
    final result = await getFavoriteListLocalMessageBoard.call(
        ParamGetFavoriteListLocalRequests(
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
    final result = await deleteFavoriteMessageBoard.call(
        ParamDeleteFavoriteRequests(
            tableName: tableName, questionNo: questionNo));

    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      Logging.log.info("remove success");
      return true;
    });
  }

  Future<String> onGetColorName(String colorCode) async {
    final result =
        await getColorName.call(ParamGetColorNameRequests(colorCode));
    String colorName = '';
    await result.fold((responseFail) async {
      return false;
    }, (responseSuccess) async {
      Logging.log.info("get color name success");
      colorName = responseSuccess;
      Logging.log.info(colorName);
      return true;
    });
    return colorName;
  }
}
