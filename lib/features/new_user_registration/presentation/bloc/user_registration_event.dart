part of 'user_registration_bloc.dart';

abstract class UserRegistrationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserRegistrationSubmitted extends UserRegistrationEvent {
  UserRegistrationSubmitted(this.id, this.tel, this.name, this.nameKana);

  final String id;
  final String tel;
  final String name;
  final String nameKana;
  @override
  List<Object> get props => [id, tel, name, nameKana];
}

class LoginSubmitted extends UserRegistrationEvent {
  LoginSubmitted(this.id, this.tel, this.isNewUser);

  final String id;
  final String tel;
  final bool isNewUser;
  @override
  List<Object> get props => [id, tel, isNewUser];
}

class RequestRegisterSubmitted extends UserRegistrationEvent {
  RequestRegisterSubmitted(this.id, this.tel, this.name, this.nameKana);

  final String id;
  final String tel;
  final String name;
  final String nameKana;
  @override
  List<Object> get props => [id, tel, name, nameKana];
}

class PersonalRegisterSubmitted extends UserRegistrationEvent {
  PersonalRegisterSubmitted(this.id, this.tel, this.name, this.nameKana);

  final String id;
  final String tel;
  final String name;
  final String nameKana;
  @override
  List<Object> get props => [id, tel, name, nameKana];
}
