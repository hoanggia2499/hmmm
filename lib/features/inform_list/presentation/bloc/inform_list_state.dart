part of 'inform_list_bloc.dart';

abstract class InformListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends InformListState {}

class Loading extends InformListState {}

class Loaded extends InformListState {}

class TimeOut extends InformListState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object?> get props => [messageCode, messageContent];
}

class Error extends InformListState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object?> get props => [messageCode, messageContent];
}

class LoadedInformListState extends InformListState {
  final List<InformListResponseModel> listInform;

  LoadedInformListState({required this.listInform});
  @override
  List<Object> get props => [listInform];
}
