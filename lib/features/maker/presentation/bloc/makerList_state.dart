import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';

@immutable
abstract class MakerListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends MakerListState {}

class Loading extends MakerListState {}

class Loaded extends MakerListState {
  final List<ItemMakerModel> makerEntity;

  Loaded({required this.makerEntity});

  @override
  List<Object> get props => [makerEntity];
}

class Error extends MakerListState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends MakerListState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}
