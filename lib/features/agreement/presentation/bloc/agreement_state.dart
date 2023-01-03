import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AgreementState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends AgreementState {}

class Loading extends AgreementState {}

class Loaded extends AgreementState {
  final String agreement;

  Loaded({required this.agreement});

  @override
  List<Object> get props => [agreement];
}

class Error extends AgreementState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends AgreementState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class SendMailState extends AgreementState {}
