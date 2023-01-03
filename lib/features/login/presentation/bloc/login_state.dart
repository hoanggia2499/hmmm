part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends LoginState {}

class Inital extends LoginState {}

class Loading extends LoginState {}

class Error extends LoginState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class UnavailableUser extends LoginState {
  final String messageCode;
  final String messageContent;

  UnavailableUser({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class LoginSuccessful extends LoginState {
  final LoginModel loginModel;
  final String? userStatus;
  final String? id;
  final String? password;
  final String? isTermsAccepted;

  LoginSuccessful(
      {this.loginModel = const LoginModel(),
      this.userStatus,
      this.id,
      this.password,
      this.isTermsAccepted});

  @override
  List<Object> get props => [
        loginModel,
        userStatus ?? '',
        id ?? '',
        password ?? '',
        isTermsAccepted ?? '0'
      ];
}

class LoginInitState extends LoginState {
  final LoginModel loginModel;
  final String? userStatus;
  final String? id;
  final String? password;
  final String? isTermsAccepted;

  LoginInitState(
      {this.loginModel = const LoginModel(),
      this.userStatus,
      this.id,
      this.password,
      this.isTermsAccepted});

  @override
  List<Object> get props => [
        loginModel,
        userStatus ?? '',
        id ?? '',
        password ?? '',
        isTermsAccepted ?? '0'
      ];
}

class CheckedUpdateState extends LoginState {
  final CheckUpdateEventAction eventAction;
  final CheckUpdateType checkUpdateType;

  CheckedUpdateState(
      {required this.eventAction, required this.checkUpdateType});
}
