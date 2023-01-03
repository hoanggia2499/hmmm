part of 'inform_detail_bloc.dart';

abstract class InformDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInformDetailEvent extends InformDetailEvent {
  final InformDetailRequestModel request;

  GetInformDetailEvent(this.request);
}

class GetCarSPEvent extends InformDetailEvent {
  final CarSPRequestModel request;

  GetCarSPEvent(this.request);
}
