part of 'user_registration_bloc.dart';

abstract class UserRegistrationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends UserRegistrationState {}

class Loading extends UserRegistrationState {}

class Loaded extends UserRegistrationState {
  final String? storeName;
  final String? personalAuthFlag;
  final bool? isExists;

  Loaded({this.storeName, this.personalAuthFlag, this.isExists});

  @override
  List<Object> get props =>
      [storeName ?? '', personalAuthFlag ?? '', isExists ?? false];
}

class Error extends UserRegistrationState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class DialogState extends UserRegistrationState {
  final String contentDialog;
  final String personalAuthFlag;
  final bool isExists;

  DialogState(
      {required this.contentDialog,
      required this.personalAuthFlag,
      required this.isExists});

  @override
  List<Object> get props => [contentDialog, personalAuthFlag, isExists];
}

class LoginState extends UserRegistrationState {
  LoginState(this.isNewUser, this.memberNum, this.userNum);

  final bool isNewUser;
  final String memberNum;
  final int userNum;
}

class RequestRegisterState extends UserRegistrationState {}

class PersonalRegisterState extends UserRegistrationState {
  final String memberNum;
  final int userNum;

  PersonalRegisterState({
    required this.memberNum,
    required this.userNum,
  });

  @override
  List<Object> get props => [memberNum, userNum];
}
