import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class AgreementEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AgreeInit extends AgreementEvent {}

class SendMailNewUserSubmitted extends AgreementEvent {
  SendMailNewUserSubmitted(this.memberNum, this.userNum, this.context);

  final String memberNum;
  final int userNum;
  final BuildContext context;
  @override
  List<Object> get props => [memberNum, userNum, context];
}
