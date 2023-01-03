import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/sell_car/presentation/bloc/sell_car_event.dart';
import 'package:mirukuru/features/sell_car/presentation/bloc/sell_car_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/util/image_util.dart' as ImageHelper;
import 'package:path/path.dart' as path;
import '../../../../core/error/error_model.dart';
import '../../../../core/util/error_code.dart';
import '../../../../core/util/image_util.dart';
import '../../../../core/widgets/common/show_and_pickup_photo_view.dart';
import '../../data/model/sell_car_delete_photo_request.dart';
import '../../data/model/sell_car_get_list_image.dart';
import '../../data/model/sell_car_upload_photo_request.dart';
import '../../domain/usecases/delete_photo.dart';
import '../../domain/usecases/get_car_images.dart';
import '../../domain/usecases/get_local_data.dart';
import '../../domain/usecases/post_sell_car.dart';
import '../../domain/usecases/upload_photo.dart';

class SellCarBloc extends Bloc<SellCarEvent, SellCarState> {
  final GetListImageSellCar getListImageSellCar;
  final PostSellCar postSellCar;
  final DeletePhotoAfterPostedSellCar deletePhoto;
  final UploadPhotoSellCar uploadPhotoSellCar;

  /// init local data source
  final SellCarGetLocalData getLocalData;
  List<PhotoData> _deletePhotoList = [];
  List<PhotoData> _uploadPhotoList = [];
  List<PhotoData> _existingPhotoList = [];

  List<PhotoData> get deletePhotoList => this._deletePhotoList;
  set deletePhotoList(List<PhotoData> value) {
    this._deletePhotoList = value;
    value.forEach((deletePhoto) {
      this._existingPhotoList.removeWhere((element) => element == deletePhoto);
    });
    add(SellCarUpdatePhoto());
  }

  List<PhotoData> get uploadPhotoList => this._uploadPhotoList;
  set uploadPhotoList(List<PhotoData> value) {
    this._uploadPhotoList = value;
    value.forEach((element) {
      if (!_existingPhotoList.contains(element))
        this._existingPhotoList.add(element);
    });
    add(SellCarUpdatePhoto());
  }

  List<PhotoData> get existingPhotoList => this._existingPhotoList;
  set existingPhotoList(List<PhotoData> value) {
    this._existingPhotoList.clear();
    this._existingPhotoList.addAll(value);
    add(SellCarUpdatePhoto());
  }

  SellCarBloc(
    this.getLocalData,
    this.postSellCar,
    this.deletePhoto,
    this.uploadPhotoSellCar,
    this.getListImageSellCar,
  ) : super(Empty()) {
    // on<SellCarInit>(_onInviteInit);
    on<GetLocalDataEvent>(_onGetLocalData);
    on<SellCarUpdatePhoto>(
      (event, emit) => emit(SellCarUpdatedPhotos()),
    );

    on<GetCarListImagesEvent>(_onGetCarImages);
    on<PostSellCarEvent>(_onPostSellCar);
    on<DeletePhotoCarRegisEvent>(_onDeletePhoto);
    on<UpLoadPhotosEvent>(_onUploadPhoto);
  }

  // Future _onInviteInit(SellCarInit event, Emitter<SellCarState> emit) async {
  //   emit(Loading());
  //   try {
  //     // call API get agreement
  //     final callGetAgreement = await getAgreement(NoParamsExt());
  //
  //     await callGetAgreement.fold((responseFail) async {
  //       Logging.log.warn(responseFail);
  //
  //       if (responseFail.msgCode.contains('5MA002SE')) {
  //         emit(TimeOut(ReponseErrorModel(
  //             msgCode: responseFail.msgCode,
  //             msgContent: responseFail.msgContent)));
  //       } else {
  //         emit(Error(ReponseErrorModel(
  //             msgCode: responseFail.msgCode,
  //             msgContent: responseFail.msgContent)));
  //       }
  //       return false;
  //     }, (responseSuccess) async {
  //       // set format string value agreement
  //       responseSuccess =
  //           responseSuccess.trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");
  //
  //       emit(Loaded(agreement: responseSuccess));
  //     });
  //   } catch (ex) {
  //     Logging.log.error(ex);
  //     emit(Error(
  //         ReponseErrorModel(msgCode: '', msgContent: 'ERROR_HAPPENDED'.tr())));
  //   }
  // }

  FutureOr<void> _onGetLocalData(
      GetLocalDataEvent event, Emitter<SellCarState> emit) async {
    emit(Loading());
    try {
      final loadLocalData = await getLocalData.call(NoParamsExt());

      await loadLocalData.fold((responseFail) async {
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
          ReponseErrorModel(msgCode: '', msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  FutureOr<void> _onPostSellCar(
      PostSellCarEvent event, Emitter<SellCarState> emit) async {
    emit(Loading());
    try {
      var request = event.request;

      final postingNewQuestion = await postSellCar.call(request);

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
          var param = event.request;

          SellCarUploadPhotoRequestModel? uploadPhotoRequest;
          if (uploadPhotoList.isNotEmpty) {
            var xFileList = await ImageHelper.ImageUtil.instance
                .compressMultiImage(uploadPhotoList);

            uploadPhotoRequest = SellCarUploadPhotoRequestModel(
              memberNum: param.memberNum,
              userNum: param.userNum,
              userCarNum: param.userCarNum,
              upKind: "1",
              files: xFileList,
            );
          }

          List<SellCarDeleteSinglePhotoRequestModel>? deleteRemotePhotoRequest;
          if (deletePhotoList.isNotEmpty) {
            deleteRemotePhotoRequest = deletePhotoList.map((e) {
              var imageUrl = e.photo as String;
              var imageName = path.basename(File(imageUrl).path);

              return SellCarDeleteSinglePhotoRequestModel(
                  memberNum: param.memberNum ?? "",
                  userNum: (param.userNum ?? 0).toString(),
                  userCarNum: (param.userCarNum ?? "").toString(),
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
              add(UpLoadPhotosEvent(uploadPhotoRequest));
            } else {
              emit(PostSuccess('登録しました'));
              return true;
            }
          }
          return true;
        },
      );
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onDeletePhoto(
      DeletePhotoCarRegisEvent event, Emitter<SellCarState> emit) async {
    try {
      var deletePhotoAgreement = await deletePhoto.call(event.request);

      await deletePhotoAgreement.fold((error) async {
        Logging.log.warn(error.msgContent);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(ReponseErrorModel(
              msgCode: error.msgCode, msgContent: error.msgContent)));
        } else {
          emit(Error(ReponseErrorModel(
              msgCode: error.msgCode, msgContent: error.msgContent)));
        }
        return false;
      }, (result) async {
        if (event.uploadPhotoRequestModel != null) {
          add(UpLoadPhotosEvent(event.uploadPhotoRequestModel!));
        } else {
          emit(PostSuccess('登録しました'));
          return true;
        }
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onGetCarImages(
      GetCarListImagesEvent event, Emitter<SellCarState> emit) async {
    try {
      var param = event.request;
      final callGetCarImages = await getListImageSellCar(
          SellCarGetCarImagesRequestModel(
              memberNum: param.memberNum,
              userNum: (param.userNum ?? 0).toString(),
              userCarNum: (param.userCarNum ?? 0).toString(),
              upKind: param.upKind));

      await callGetCarImages.fold((responseFail) async {
        print(responseFail);

        if (responseFail.msgCode.contains('5MA002SE')) {
          emit(TimeOut(ReponseErrorModel(
              msgCode: responseFail.msgCode,
              msgContent: responseFail.msgContent)));
        } else {
          emit(Error(ReponseErrorModel(
              msgCode: responseFail.msgCode,
              msgContent: responseFail.msgContent)));
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
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }

  Future _onUploadPhoto(
      UpLoadPhotosEvent event, Emitter<SellCarState> emit) async {
    try {
      var uploadingPhoto = await uploadPhotoSellCar.call(event.request);
      await uploadingPhoto.fold((error) async {
        Logging.log.warn(error.msgCode);

        if (error.msgCode.contains(ErrorCode.MA002SE)) {
          emit(TimeOut(ReponseErrorModel(
              msgCode: error.msgCode, msgContent: error.msgContent)));
        } else {
          emit(Error(ReponseErrorModel(
              msgCode: error.msgCode, msgContent: error.msgContent)));
        }
        return false;
      }, (result) async {
        emit(PostSuccess('登録しました'));
        return true;
      });
    } catch (e) {
      Logging.log.error(e);
      emit(Error(
          ReponseErrorModel(msgCode: "", msgContent: 'ERROR_HAPPENDED'.tr())));
    }
  }
}
