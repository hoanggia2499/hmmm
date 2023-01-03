import 'package:equatable/equatable.dart';

import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/store_information/data/models/store_information_model.dart';

abstract class StoreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends StoreState {}

class Empty extends StoreState {}

class Error extends StoreState {
  final ReponseErrorModel errorModel;

  Error(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class TimeOut extends StoreState {
  final ReponseErrorModel errorModel;

  TimeOut(this.errorModel);

  @override
  List<Object?> get props => [errorModel.msgCode, errorModel.msgContent];
}

class Loaded extends StoreState {
  final StoreInformationModel? storeInformation;

  Loaded({
    this.storeInformation,
  });
}
