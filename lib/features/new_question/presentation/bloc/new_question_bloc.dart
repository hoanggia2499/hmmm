import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_model.dart';
import 'package:mirukuru/features/new_question/data/models/upload_photo_request.dart';
import 'package:mirukuru/features/new_question/domain/usecases/delete_photo_after_posted.dart';
import 'package:mirukuru/features/new_question/domain/usecases/get_local_data.dart';
import 'package:mirukuru/features/new_question/domain/usecases/get_user_info.dart';
import 'package:mirukuru/features/new_question/domain/usecases/post_question.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../../../core/util/error_code.dart';
import '../../../../core/util/logger_util.dart';
import '../../../../core/widgets/common/show_and_pickup_photo_view.dart';
import '../../../my_page/data/models/user_car_name_request_model.dart';
import '../../data/models/user_info_request_model.dart';
import '../../data/models/user_info_response_model.dart';
import '../../data/models/new_question_model.dart';
import '../../domain/usecases/get_car_name.dart';
import '../../domain/usecases/upload_photo.dart';
part 'new_question_event.dart';
part 'new_question_state.dart';

class NewQuestionBloc extends Bloc<NewQuestionEvent, NewQuestionState> {
  final GetUserInfo getUserInfo;
  final GetNewQuestionCarList getCarList;
  final PostNewQuestionNow postNewQuestionNow;
  final DeletePhotoAfterPosted deletePhotoAfterPosted;
  final UploadPhoto uploadPhoto;

  /// local data
  final GetLocalData getListNameBeanHive;
  List<PhotoData> _deletePhotoList = [];
  List<PhotoData> _uploadPhotoList = [];
  List<PhotoData> _existingPhotoList = [];

  List<PhotoData> get deletePhotoList => this._deletePhotoList;
  set deletePhotoList(List<PhotoData> value) {
    this._deletePhotoList = value;
    value.forEach((deletePhoto) {
      this._existingPhotoList.removeWhere((element) => element == deletePhoto);
    });
    add(NewQuestionUpdatePhoto());
  }

  List<PhotoData> get uploadPhotoList => this._uploadPhotoList;
  set uploadPhotoList(List<PhotoData> value) {
    this._uploadPhotoList = value;
    value.forEach((element) {
      if (!_existingPhotoList.contains(element))
        this._existingPhotoList.add(element);
    });
    add(NewQuestionUpdatePhoto());
  }

  List<PhotoData> get existingPhotoList => this._existingPhotoList;
  set existingPhotoList(List<PhotoData> value) {
    this._existingPhotoList.clear();
    this._existingPhotoList.addAll(value);
    add(NewQuestionUpdatePhoto());
  }

  NewQuestionBloc(this.getUserInfo, this.getCarList, this.postNewQuestionNow,
      this.deletePhotoAfterPosted, this.uploadPhoto, this.getListNameBeanHive)
      : super(Empty()) {
    on<NewQuestionInitEvent>(_onNewQuestionInit);
    on<PostNewQuestionEvent>(_onPostNewQuestionNow);
    on<DeleteAllPhotosEvent>(_onDeletePhotoAfterPosted);
    on<UpLoadPhotosEvent>(_onUpdatePhoto);
    on<OnSelectDivisionEvent>(_onSelectDivision);
    on<OnSelectOwnerCarEvent>(_onSelectOwnerCar);
    on<NewQuestionUpdatePhoto>(
      (event, emit) => emit(UpdatedPhotos()),
    );
    on<GetLocalDataEvent>(_onGetLocalData);
  }

  Future _onNewQuestionInit(
      NewQuestionInitEvent event, Emitter<NewQuestionState> emit) async {
    emit(Loading());
    try {
      final creatingUserInfo = await getUserInfo.call(event.request);

      await creatingUserInfo.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }
        return false;
      }, (result) async {
        if (result == null) {
          emit(Empty());
        }
        await _onGetCarList(result!, emit);
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onGetCarList(UserInfoResponseModel userInfoResponseModel,
      Emitter<NewQuestionState> emit) async {
    emit(Loading());
    try {
      final List<UserCarNameRequestModel> requestCarList = userInfoResponseModel
              .userCarList
              ?.map((e) => UserCarNameRequestModel(
                  makerCode: e.makerCode, carCode: e.carCode))
              .toList() ??
          List.empty();

      final loadingUserCarNameList = await getCarList.call(requestCarList);

      loadingUserCarNameList.fold((error) async {
        Logging.log.warn(error.toString());

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }
        return false;
      }, (result) async {
        if (result != null && result.isNotEmpty) {
          var rs = result.map((e) {
            var userCarNum = userInfoResponseModel.userCarList
                ?.firstWhere((userCar) =>
                    e.makerCode == userCar.makerCode &&
                    e.asnetCarCode == userCar.carCode)
                .userCarNum;
            e.userCarNum = userCarNum;
            return e;
          }).toList();
          emit(LoadedCarListState(rs));
        }
        emit(LoadedCarListState([]));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onPostNewQuestionNow(
      PostNewQuestionEvent event, Emitter<NewQuestionState> emit) async {
    emit(Loading());
    try {
      var request = event.request;

      final postingNewQuestion = await postNewQuestionNow.call(request);

      postingNewQuestion.fold(
        (error) async {
          Logging.log.warn(error.toString());

          if (error.msgCode.contains(ErrorCode.MA002SE)) {
            emit(TimeOut(error));
          } else {
            emit(Error(error));
          }
          return false;
        },
        (result) async {
          add(
            DeleteAllPhotosEvent(request),
          );
          return true;
        },
      );
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onDeletePhotoAfterPosted(
      DeleteAllPhotosEvent event, Emitter<NewQuestionState> emit) async {
    try {
      final deletingPhotoAfterPosted =
          await deletePhotoAfterPosted.call(event.request);

      var request = event.request;

      deletingPhotoAfterPosted.fold((error) async {
        Logging.log.warn(error.toString());

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }
        return false;
      }, (result) async {
        if (request.files != null && (request.files ?? []).isNotEmpty) {
          add(
            UpLoadPhotosEvent(
              UploadPhotoRequestModel(
                  upKind: request.upKind,
                  userNum: request.userNum,
                  userCarNum: request.userCarNum,
                  memberNum: request.memberNum,
                  files: request.files),
            ),
          );
        } else {
          emit(DeletedOnPhotoSuccessState("5MY001SI", "処理が実行されました。"));
        }

        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  FutureOr<void> _onSelectDivision(
      OnSelectDivisionEvent event, Emitter<NewQuestionState> emit) {
    emit(OnSelectDivisionState(event.indexSelectQuestionKbnType));
  }

  FutureOr<void> _onSelectOwnerCar(
      OnSelectOwnerCarEvent event, Emitter<NewQuestionState> emit) {
    emit(OnSelectOwnerCarState(event.indexSelectOwnerCar));
  }

  FutureOr<void> _onUpdatePhoto(
      UpLoadPhotosEvent event, Emitter<NewQuestionState> emit) async {
    try {
      final uploadingPhoto = await uploadPhoto.call(event.request);
      uploadingPhoto.fold((error) async {
        Logging.log.warn(error.msgCode);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(error));
        } else {
          emit(Error(error));
        }
        return false;
      }, (result) async {
        emit(UploadedPhotoState("5MY001SI", "処理が実行されました。"));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  FutureOr<void> _onGetLocalData(
      GetLocalDataEvent event, Emitter<NewQuestionState> emit) async {
    emit(Loading());
    try {
      final loadItemSearchHistoryAgreement =
          await getListNameBeanHive.call(NoParamsExt());

      await loadItemSearchHistoryAgreement.fold((responseFail) async {
        emit(Error(ReponseErrorModel(
            msgCode: responseFail.msgCode,
            msgContent: responseFail.msgContent)));
        return false;
      }, (responseSuccess) async {
        emit(InitLocalData(responseSuccess));
        return true;
      });
    } catch (ex) {
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: "ERROR_HAPPENDED".tr())));
    }
  }
}
