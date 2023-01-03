import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';

abstract class InviteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends InviteState {}

class Loading extends InviteState {}

class InvitedFriend extends InviteState {}

class Error extends InviteState {
  final ReponseErrorModel errorModel;

  Error(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class TimeOut extends InviteState {
  final ReponseErrorModel errorModel;

  TimeOut(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}
