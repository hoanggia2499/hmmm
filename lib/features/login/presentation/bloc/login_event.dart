part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted(this.id, this.pass);

  final String id;
  final String pass;
  @override
  List<Object> get props => [id, pass];
}

class LoginValidate extends LoginEvent {
  LoginValidate(this.id, this.pass);
  final String id;
  final String pass;
  @override
  List<Object> get props => [id, pass];
}

class LoginInit extends LoginEvent {}

class CheckUpdateEvent extends LoginEvent {
  final BuildContext context;
  final CheckUpdateEventAction eventAction;

  CheckUpdateEvent(
      {required this.context,
      this.eventAction = CheckUpdateEventAction.firstLaunchApp});
}

enum CheckUpdateEventAction {
  firstLaunchApp,
  beforeProcessingLogin,
  beforeProcessingSignUp,
}
