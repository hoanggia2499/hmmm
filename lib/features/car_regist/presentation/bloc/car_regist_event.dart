import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/features/car_regist/data/model/post_own_car_request.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';

import '../../../message_board/data/models/delele_single_photo_request.model.dart';
import '../../../message_board/data/models/upload_photo_request_model.dart';
import '../../data/model/local_data_model.dart';
import '../../data/model/delete_own_car_request.dart';
import '../../data/model/get_car_images_request.dart';

abstract class CarRegisEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCarListEvent extends CarRegisEvent {
  GetCarListEvent(this.caller, this.context, this.makerCode);

  final String caller;
  final BuildContext context;
  final String makerCode;
  @override
  List<Object> get props => [caller, context, makerCode];
}

class OpenCarTypePicker extends CarRegisEvent {
  final BuildContext context;
  final LoginModel loginModel;
  final String makerCode;
  OpenCarTypePicker(this.context, this.loginModel, this.makerCode);

  @override
  List<Object?> get props => [context, loginModel, makerCode];
}

class OpenMakerCodePicker extends CarRegisEvent {
  final BuildContext context;
  final LoginModel loginModel;
  final ItemMakerModel? initMakerCode;

  OpenMakerCodePicker(
      {required this.context, required this.loginModel, this.initMakerCode});

  @override
  List<Object?> get props => [context, loginModel, initMakerCode];
}

class GetLocalDataEvent extends CarRegisEvent {}

class OnSelectRIKUJIEvent extends CarRegisEvent {
  final RIKUJIModel value;

  OnSelectRIKUJIEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class OnChangeInputTextFieldEvent extends CarRegisEvent {
  final InputTextModel modelText;

  OnChangeInputTextFieldEvent(this.modelText);

  @override
  List<Object?> get props => [modelText];
}

class OnChangeSelectionFieldEvent extends CarRegisEvent {
  final SelectionFieldModel modelSelection;
  OnChangeSelectionFieldEvent(this.modelSelection);

  @override
  List<Object?> get props => [modelSelection];
}

class GetCarListImagesEvent extends CarRegisEvent {
  final GetCarImagesRequestModel request;

  GetCarListImagesEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}

class PostOwnCarEvent extends CarRegisEvent {
  final PostOwnCarRequestModel request;

  PostOwnCarEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}

class DeleteOwnCarEvent extends CarRegisEvent {
  final DeleteOwnCarRequestModel request;
  DeleteOwnCarEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class UploadPhotoEvent extends CarRegisEvent {
  @override
  List<Object?> get props => super.props;
}

class UploadFileCarRegisEvent extends CarRegisEvent {
  final List<DeleteSinglePhotoRequestModel>? deleteRemotePhotoRequest;
  final PhotoUploadRequestModel? uploadPhotoRequestModel;

  UploadFileCarRegisEvent(
      {this.deleteRemotePhotoRequest, this.uploadPhotoRequestModel});

  @override
  List<Object> get props => [];
}

class DeletePhotoCarRegisEvent extends CarRegisEvent {
  final List<DeleteSinglePhotoRequestModel> request;
  final PhotoUploadRequestModel? uploadPhotoRequestModel;

  DeletePhotoCarRegisEvent(this.request, this.uploadPhotoRequestModel);

  @override
  List<Object> get props => [request];
}

class UploadPhotoCarRegisEvent extends CarRegisEvent {
  final PhotoUploadRequestModel request;

  UploadPhotoCarRegisEvent(this.request);

  @override
  List<Object> get props => [request];
}

class UpdatePhotoCarRegisEvent extends CarRegisEvent {
  @override
  List<Object?> get props => super.props;
}
