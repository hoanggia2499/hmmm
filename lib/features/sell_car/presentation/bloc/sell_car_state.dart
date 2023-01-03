import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';

import '../../../../core/error/error_model.dart';

@immutable
abstract class SellCarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends SellCarState {}

class Loading extends SellCarState {}

class Loaded extends SellCarState {
  final String agreement;

  Loaded({required this.agreement});

  @override
  List<Object> get props => [agreement];
}

class TimeOut extends SellCarState {
  final ReponseErrorModel errorModel;

  TimeOut(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class Error extends SellCarState {
  final ReponseErrorModel errorModel;

  Error(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class InitLocalData extends SellCarState {
  final List<NameBeanHive> listNameBeanHive;

  InitLocalData(this.listNameBeanHive);

  @override
  List<Object?> get props => [listNameBeanHive];
}

class SellCarUpdatedPhotos extends SellCarState {
  final DateTime updatedTime;

  SellCarUpdatedPhotos() : this.updatedTime = DateTime.now();

  @override
  List<Object> get props => [this.updatedTime];
}

class CarListImagesLoaded extends SellCarState {
  final List<String> images;

  CarListImagesLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

class DeletedOnPhotoSuccessState extends SellCarState {
  final String informationCode;
  final String informationMessage;

  DeletedOnPhotoSuccessState(this.informationCode, this.informationMessage);
  @override
  List<Object?> get props => [informationCode, informationMessage];
}

class UploadedPhotoState extends SellCarState {
  final String informationCode;
  final String informationMessage;

  UploadedPhotoState(this.informationCode, this.informationMessage);
  @override
  List<Object?> get props => [informationCode, informationMessage];
}

class PostSuccess extends SellCarState {
  final String success;

  PostSuccess(this.success);
  @override
  List<Object?> get props => [success];
}
