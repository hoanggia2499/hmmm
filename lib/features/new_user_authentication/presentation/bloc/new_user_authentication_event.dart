part of 'new_user_authentication_bloc.dart';

abstract class NewUserAuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserAuthenticationSubmitted extends NewUserAuthenticationEvent {
  UserAuthenticationSubmitted(
      this.id, this.tel, this.name, this.nameKana, this.code);
  final int id;
  final String tel;
  final String name;
  final String nameKana;
  final String code;
  @override
  List<Object> get props => [code];
}

class LoginSubmitted extends NewUserAuthenticationEvent {
  LoginSubmitted(this.id, this.tel, this.isNewUser);

  final int id;
  final String tel;
  final bool isNewUser;
  @override
  List<Object> get props => [id, tel, isNewUser];
}

class NewUserAuthenticationInit extends NewUserAuthenticationEvent {}

class PersonalRegisterEvent extends NewUserAuthenticationEvent {
  PersonalRegisterEvent(this.id, this.tel, this.name, this.nameKana);
  final int id;
  final String tel;
  final String name;
  final String nameKana;
  @override
  List<Object> get props => [id, tel, name, nameKana];
}
