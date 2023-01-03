import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';

@immutable
abstract class BodyListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends BodyListState {}

class Loading extends BodyListState {}

class Loaded extends BodyListState {
  final List<BodyModel> listBodyModel;

  Loaded({required this.listBodyModel});

  @override
  List<Object> get props => [listBodyModel];
}

class Error extends BodyListState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends BodyListState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class AddLocalSuccess extends BodyListState {}

class DeleteLocalSuccess extends BodyListState {}
