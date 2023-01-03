part of 'inform_detail_bloc.dart';

abstract class InformDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends InformDetailState {}

class Loading extends InformDetailState {}

class Loaded extends InformDetailState {}

class TimeOut extends InformDetailState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object?> get props => [messageCode, messageContent];
}

class OnCarSPLinkAccessState extends InformDetailState {
  final ItemSearchModel itemSearchModel;

  OnCarSPLinkAccessState({required this.itemSearchModel});

  @override
  List<Object?> get props => [itemSearchModel];
}

class Error extends InformDetailState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object?> get props => [messageCode, messageContent];
}
