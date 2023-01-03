part of 'inform_list_bloc.dart';

abstract class InformListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInformListEvent extends InformListEvent {
  final InformListRequestModel request;

  GetInformListEvent(this.request);
}
