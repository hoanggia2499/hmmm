part of 'new_user_authentication_bloc.dart';

abstract class NewUserAuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends NewUserAuthenticationState {}

class Loading extends NewUserAuthenticationState {}

class Loaded extends NewUserAuthenticationState {
  final String authentication;

  Loaded({required this.authentication});

  @override
  List<Object> get props => [authentication];
}

class Error extends NewUserAuthenticationState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends NewUserAuthenticationState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class Authenticated extends NewUserAuthenticationState {}

class RegistrationCompleted extends NewUserAuthenticationState {}

class AlreadyExists extends NewUserAuthenticationState {}

class LoginState extends NewUserAuthenticationState {
  LoginState(this.isNewUser, this.memberNum, this.userNum);

  final bool isNewUser;
  final String memberNum;
  final int userNum;
}
