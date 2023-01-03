import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/util/image_util.dart' as ImageHelper;
import 'package:path/path.dart' as path;
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/features/car_regist/domain/usecases/delete_own_car.dart';
import 'package:mirukuru/features/car_regist/domain/usecases/get_car_images.dart';
import 'package:mirukuru/features/car_regist/presentation/bloc/car_regist_event.dart';
import 'package:mirukuru/features/car_regist/presentation/bloc/car_regist_state.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/carlist/domain/usecases/get_carList.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';
import 'package:mirukuru/features/maker/domain/usecases/get_makerList.dart';
import 'package:collection/collection.dart';

import '../../../../core/resources/text_styles.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../../../core/util/image_util.dart';
import '../../../../core/util/logger_util.dart';
import '../../../../core/widgets/common/show_and_pickup_photo_view.dart';
import '../../../message_board/data/models/delele_single_photo_request.model.dart';
import '../../../message_board/data/models/upload_photo_request_model.dart';
import '../../data/model/delete_own_car_request.dart';
import '../../data/model/get_car_images_request.dart';
import '../../data/model/post_own_car_request.dart';
import '../../domain/usecases/delete_photo.dart';
import '../../domain/usecases/get_local_data.dart';
import '../../domain/usecases/post_own_car.dart';
import '../../domain/usecases/upload_photo.dart';
import '../widgets/car_type_picker.dart';
import '../widgets/maker_code_picker.dart';

class CarRegisBloc extends Bloc<CarRegisEvent, CarRegisState> {
  final GetCarList getCarList;
  final GetMakerList getMakerList;
  final GetListImage getCarImages;
  final DeleteOwnCar deleteOwnCar;
  final PostOwnCar postOwnCar;
  final DeletePhotoCarRegis deletePhoto;
  final UploadPhotoCarRegis uploadPhoto;

  /// local data
  final GetListRIKUJI getListRIKUJI;

  List<ItemMakerModel> _makerList = [];
  ItemMakerModel? _selectedMaker;
  String _initCarType = "";
  List<String> carImages = [];
  List<CarModel> _carTypeByMaker = [];

  String get initCarType => this._initCarType;

  set initCarType(String value) => this._initCarType = value;

  List<PhotoData> _deletePhotoList = [];
  List<PhotoData> _uploadPhotoList = [];
  List<PhotoData> _existingPhotoList = [];

  List<PhotoData> get deletePhotoList => this._deletePhotoList;
  set deletePhotoList(List<PhotoData> value) {
    this._deletePhotoList = value;
    value.forEach((deletePhoto) {
      this._existingPhotoList.removeWhere((element) => element == deletePhoto);
    });
    add(UploadPhotoEvent());
  }

  List<PhotoData> get uploadPhotoList => this._uploadPhotoList;
  set uploadPhotoList(List<PhotoData> value) {
    this._uploadPhotoList = value;
    value.forEach((element) {
      if (!_existingPhotoList.contains(element))
        this._existingPhotoList.add(element);
    });
    add(UploadPhotoEvent());
  }

  List<PhotoData> get existingPhotoList => this._existingPhotoList;
  set existingPhotoList(List<PhotoData> value) {
    this._existingPhotoList.clear();
    this._existingPhotoList.addAll(value);
    add(UploadPhotoEvent());
  }

  CarRegisBloc(
      this.getCarList,
      this.getMakerList,
      this.getCarImages,
      this.deleteOwnCar,
      this.postOwnCar,
      this.getListRIKUJI,
      this.deletePhoto,
      this.uploadPhoto)
      : super(Empty()) {
    on<OpenCarTypePicker>(_onShowCarTypePicker);
    on<OpenMakerCodePicker>(_onShowMakerCodePicker);
    on<GetCarListImagesEvent>(_onGetCarImages);
    on<DeleteOwnCarEvent>(_onDeleteOwnCar);
    on<UploadPhotoEvent>(
      (event, emit) => emit(UpdatedPhotos()),
    );
    on<DeletePhotoCarRegisEvent>(_onDeletePhoto);
    on<UploadPhotoCarRegisEvent>(_onUploadPhoto);

    on<PostOwnCarEvent>(_onPostOwnCar);
    on<GetLocalDataEvent>(_onGetLocalData);

    /// Controller field dropdown, input,...

    on<OnSelectRIKUJIEvent>(_onSelectRIKUJI);
    on<OnChangeInputTextFieldEvent>(_onChangeInputTextField);
    on<OnChangeSelectionFieldEvent>(_onChangeInsuranceExpirationDate);
  }

  // Future _onGetCarListInit(
  //     OpenMakerCodePicker event, Emitter<CarRegisState> emit) async {
  //   try {
  //     final callGetCarList = await getCarList(ParamCarListRequests(
  //         makerCode: _selectedMaker!.makerCode, caller: "CarRegistActivity"));
  //
  //     await callGetCarList.fold((responseFail) async {
  //       print(responseFail);
  //
  //       if (responseFail.msgCode.contains('5MA002SE')) {
  //         emit(TimeOut(
  //             messageCode: responseFail.msgCode,
  //             messageContent: responseFail.msgContent));
  //       } else {
  //         emit(Error(
  //             messageCode: responseFail.msgCode,
  //             messageContent: responseFail.msgContent));
  //       }
  //       return false;
  //     }, (responseSuccess) async {
  //       _carTypeByMaker = responseSuccess;
  //
  //       return true;
  //     });
  //   } catch (ex) {
  //     emit(Error(
  //         messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
  //   }
  // }

  Future _onGetCarImages(
      GetCarListImagesEvent event, Emitter<CarRegisState> emit) async {
    try {
      var param = event.request;
      final callGetCarImages = await getCarImages(GetCarImagesRequestModel(
          memberNum: param.memberNum,
          userNum: param.userNum,
          userCarNum: param.userCarNum,
          upKind: param.upKind));

      await callGetCarImages.fold((responseFail) async {
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
      }, (result) async {
        if (result.length > 0 && result.isNotEmpty) {
          result.retainWhere((element) =>
              ImageUtil.instance.isAcceptExtension(element.split(".").last));
        }
        emit(CarListImagesLoaded(result));
        return true;
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future _onShowCarTypePicker(
      OpenCarTypePicker event, Emitter<CarRegisState> emit) async {
    if (event.makerCode.isNotEmpty) {
      emit(Loading());

      try {
        if (_selectedMaker == ItemMakerModel(makerCode: event.makerCode)) {
          await _showCarTypePicker(event, emit);
        } else {
          final callGetCarList = await getCarList(ParamCarListRequests(
              makerCode: event.makerCode, caller: "CarRegistActivity"));

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
            _carTypeByMaker = responseSuccess;
            return await _showCarTypePicker(event, emit);
          });
        }
      } catch (ex) {
        emit(Error(
            messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
      }
    } else {
      await CommonDialog.displayConfirmOneButtonDialog(
        event.context,
        TextWidget(
          label: "SELECT_A_MANUFACTURER_WARNING".tr(),
          textStyle: MKStyle.t14R,
          alignment: TextAlign.start,
        ),
        'OK',
        "OK".tr(),
        okEvent: () async {},
        cancelEvent: () {},
      );
    }
  }

  Future<bool> _showCarTypePicker(
      OpenCarTypePicker event, Emitter<CarRegisState> emit) async {
    _selectedMaker = ItemMakerModel(makerCode: event.makerCode);

    var initCarModel = _carTypeByMaker
        .firstWhereOrNull((element) => element.asnetCarCode == _initCarType);

    emit(CarTypePickerShowing());
    await showCarTypePickerDialog(event.context, initCarModel, event.loginModel,
        (selectedCarType) {
      //010|1000030|ヴェルファイア
      final parts = selectedCarType.split("|");
      String carCode = parts[1]; // 1000030
      String carTypeName = parts[2]; // ヴェルファイア
      _initCarType = carCode;

      emit(CarTypePickerPopped(
          selectedCarCode: carCode, selectedCarTypeName: carTypeName));
    });
    return true;
  }

  Future<void> showCarTypePickerDialog(
      BuildContext context,
      CarModel? initCarModel,
      LoginModel loginModel,
      Function(String) onEmitStateChange) {
    return CommonDialog.displayFullScreenDialog(
        context,
        CarTypePickerDialog(
          initCarModel: initCarModel,
          listCarModel: _carTypeByMaker,
          loginModel: loginModel,
          onPopCallback: (value) {
            onEmitStateChange.call(value);
            Navigator.pop(context);
          },
        ));
  }

  Future _onMakerListInit(
      OpenMakerCodePicker event, Emitter<CarRegisState> emit) async {
    if (_makerList.isNotEmpty) return true;

    try {
      final callGetMakerList = await getMakerList(NoParamsExt());

      await callGetMakerList.fold((responseFail) async {
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
        _makerList = responseSuccess;
        return true;
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future _onShowMakerCodePicker(
      OpenMakerCodePicker event, Emitter<CarRegisState> emit) async {
    emit(Loading());
    await _onMakerListInit(event, emit).whenComplete(() async {
      emit(MakerCodeDialogShowing());

      var initItemMakerModel = _makerList.firstWhereOrNull(
          (element) => element.makerCode == event.initMakerCode?.makerCode);

      await CommonDialog.displayFullScreenDialog(
        event.context,
        MakerCodePickerDialog(
          initMaker: initItemMakerModel,
          makerList: _makerList,
          loginModel: event.loginModel,
          onPopCallback: (selectedMaker) async {
            if (selectedMaker != _selectedMaker) {
              _initCarType = "";
            }
            _selectedMaker = selectedMaker;

            emit(MakerCodeDialogPopped(selectedMaker));
            Navigator.pop(event.context);
          },
        ),
      );
    });
  }

  Future _onDeleteOwnCar(
      DeleteOwnCarEvent event, Emitter<CarRegisState> emit) async {
    try {
      var param = event.request;
      final callGetCarList = await deleteOwnCar(DeleteOwnCarRequestModel(
          memberNum: param.memberNum,
          userCarNum: param.userCarNum,
          userNum: param.userNum));

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
        emit(DeleteOwnCarLoaded(responseSuccess));
        return true;
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  FutureOr<void> _onPostOwnCar(
      PostOwnCarEvent event, Emitter<CarRegisState> emit) async {
    try {
      var param = event.request;
      final callGetCarList = await postOwnCar(
        PostOwnCarRequestModel(
          memberNum: param.memberNum,
          userNum: param.userNum,
          userCarNum: param.userCarNum,
          plateNo1: param.plateNo1,
          plateNo2: param.plateNo2,
          plateNo3: param.plateNo3,
          plateNo4: param.plateNo4,
          makerCode: param.makerCode,
          carCode: param.carCode,
          carGrade: param.carGrade,
          carModel: param.carModel,
          platformNum: param.platformNum,
          bodyColor: param.bodyColor,
          mileage: param.mileage,
          inspectionDate: param.inspectionDate,
          inspectionFlag: param.inspectionFlag,
          sellTime: param.sellTime,
          buyTime: param.buyTime,
          nHokenKbn: param.nHokenKbn,
          nHokenInc: param.nHokenInc,
          nHokenEndDay: param.nHokenEndDay,
        ),
      );

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
        // emit(PostSuccess('登録しました'));

        // var uploadPhotoList =
        //     context.read<MessageBoardBloc>().uploadPhotoList;

        PhotoUploadRequestModel? uploadPhotoRequest;
        if (uploadPhotoList.isNotEmpty) {
          var xFileList = await ImageHelper.ImageUtil.instance
              .compressMultiImage(uploadPhotoList);

          uploadPhotoRequest = PhotoUploadRequestModel(
            memberNum: param.memberNum,
            userNum: param.userNum,
            userCarNum: responseSuccess.userCarNum,
            upKind: "1",
            files: xFileList,
          );
        }

        // var deletePhotoList =
        //     context.read<MessageBoardBloc>().deletePhotoList;
        List<DeleteSinglePhotoRequestModel>? deleteRemotePhotoRequest;
        if (deletePhotoList.isNotEmpty) {
          deleteRemotePhotoRequest = deletePhotoList.map((e) {
            var imageUrl = e.photo as String;
            var imageName = path.basename(File(imageUrl).path);

            return DeleteSinglePhotoRequestModel(
                memberNum: param.memberNum.toString(),
                userNum: param.userNum.toString(),
                userCarNum: responseSuccess.userCarNum.toString(),
                upKind: "1",
                imgName: imageName);
          }).toList();
        }
        if (deleteRemotePhotoRequest != null &&
            deleteRemotePhotoRequest.isNotEmpty) {
          add(DeletePhotoCarRegisEvent(
              deleteRemotePhotoRequest, uploadPhotoRequest));
        } else {
          if (uploadPhotoRequest != null) {
            add(UploadPhotoCarRegisEvent(uploadPhotoRequest));
          } else {
            emit(PostSuccess('登録しました'));
            return true;
          }
        }
        return true;
      });
    } catch (ex) {
      emit(Error(
          messageCode: '5MA013CE', messageContent: ErrorCode.MA013CE.tr()));
    }
  }

  FutureOr<void> _onGetLocalData(
      GetLocalDataEvent event, Emitter<CarRegisState> emit) async {
    emit(Loading());
    try {
      final loadItemSearchHistoryAgreement =
          await getListRIKUJI.call(NoParamsExt());

      await loadItemSearchHistoryAgreement.fold((responseFail) async {
        emit(Error(
            messageCode: responseFail.msgCode,
            messageContent: responseFail.msgContent));
        return false;
      }, (responseSuccess) async {
        emit(InitLocalData(responseSuccess));
        return true;
      });
    } catch (ex) {
      emit(Error(messageCode: '', messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  FutureOr<void> _onSelectRIKUJI(
      OnSelectRIKUJIEvent event, Emitter<CarRegisState> emit) {
    emit(ChangeRIKUJIState(event.value));
  }

  FutureOr<void> _onChangeInputTextField(
      OnChangeInputTextFieldEvent event, Emitter<CarRegisState> emit) {
    emit(ChangeInputTextState(event.modelText));
  }

  FutureOr<void> _onChangeInsuranceExpirationDate(
      OnChangeSelectionFieldEvent event, Emitter<CarRegisState> emit) {
    emit(ChangeSelectionFieldState(event.modelSelection));
  }

  Future _onDeletePhoto(
      DeletePhotoCarRegisEvent event, Emitter<CarRegisState> emit) async {
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
          add(UploadPhotoCarRegisEvent(event.uploadPhotoRequestModel!));
        } else {
          emit(PostSuccess('登録しました'));
          return true;
        }
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }

  Future _onUploadPhoto(
      UploadPhotoCarRegisEvent event, Emitter<CarRegisState> emit) async {
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
        emit(PostSuccess('登録しました'));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(messageCode: "", messageContent: 'ERROR_HAPPENDED'.tr()));
    }
  }
}
