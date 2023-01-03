part of 'about_bloc.dart';

abstract class AboutState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends AboutState {}

class Loading extends AboutState {}

class Loaded extends AboutState {
  final String agreement;

  Loaded({required this.agreement});

  @override
  List<Object> get props => [agreement];
}

class Error extends AboutState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends AboutState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}
