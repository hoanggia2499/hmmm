import 'package:equatable/equatable.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';

abstract class CarListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends CarListState {}

class Loading extends CarListState {}

class Loaded extends CarListState {
  final List<CarModel> listCarModel;

  Loaded({required this.listCarModel});

  @override
  List<Object> get props => [listCarModel];
}

class Error extends CarListState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends CarListState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class AddLocalSuccess extends CarListState {}

class DeleteLocalSuccess extends CarListState {}
