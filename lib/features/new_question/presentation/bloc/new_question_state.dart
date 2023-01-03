part of 'new_question_bloc.dart';

abstract class NewQuestionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends NewQuestionState {}

class Loading extends NewQuestionState {}

class Loaded extends NewQuestionState {}

class TimeOut extends NewQuestionState {
  final ReponseErrorModel errorModel;

  TimeOut(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class Error extends NewQuestionState {
  final ReponseErrorModel errorModel;

  Error(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class OnSelectDivisionState extends NewQuestionState {
  final int indexSelectQuestionKbnType;
  OnSelectDivisionState(this.indexSelectQuestionKbnType);

  @override
  List<Object?> get props => [indexSelectQuestionKbnType];
}

class OnSelectOwnerCarState extends NewQuestionState {
  final int indexSelectOwnerCar;
  OnSelectOwnerCarState(this.indexSelectOwnerCar);

  @override
  List<Object?> get props => [indexSelectOwnerCar];
}

class LoadedCarListState extends NewQuestionState {
  final List<UserCarNameModel>? listUserCarNameModel;

  LoadedCarListState(this.listUserCarNameModel);
}

class DeletedOnPhotoSuccessState extends NewQuestionState {
  final String informationCode;
  final String informationMessage;

  DeletedOnPhotoSuccessState(this.informationCode, this.informationMessage);
}

class UploadedPhotoState extends NewQuestionState {
  final String informationCode;
  final String informationMessage;

  UploadedPhotoState(this.informationCode, this.informationMessage);
}

class UpdatedPhotos extends NewQuestionState {
  final DateTime updatedTime;

  UpdatedPhotos() : this.updatedTime = DateTime.now();

  @override
  List<Object> get props => [this.updatedTime];
}

class InitLocalData extends NewQuestionState {
  final List<NameBeanHive> listNameBean;

  InitLocalData(this.listNameBean);

  @override
  List<Object?> get props => [listNameBean];
}
