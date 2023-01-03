import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStoreInformationEvent extends StoreEvent {
  final String memberNum;

  LoadStoreInformationEvent({
    required this.memberNum,
  });
}
