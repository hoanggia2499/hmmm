import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_input_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_model.dart';

abstract class MyPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends MyPageState {}

class MyPageInfoLoaded extends MyPageState {
  final MyPageInputModel? myPageModel;

  MyPageInfoLoaded(this.myPageModel);
}

class Empty extends MyPageState {}

class Error extends MyPageState {
  final ReponseErrorModel errorModel;

  Error(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class TimeOut extends MyPageState {
  final ReponseErrorModel errorModel;

  TimeOut(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class MyPageInfoUpdated extends MyPageState {
  final String informationCode;
  final String informationMessage;

  MyPageInfoUpdated(this.informationCode, this.informationMessage);
}

class UserCarNameListLoaded extends MyPageState {
  final List<UserCarNameModel> userCarNameList;

  UserCarNameListLoaded(this.userCarNameList);
}

class UpdatedSelectedUserCarName extends MyPageState {}
