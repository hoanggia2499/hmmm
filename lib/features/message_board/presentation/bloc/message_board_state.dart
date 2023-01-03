import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:mirukuru/features/message_board/data/models/message_board_detail_model.dart';

@immutable
abstract class MessageBoardState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends MessageBoardState {}

class Loading extends MessageBoardState {}

class Loaded extends MessageBoardState {
  final MessageBoardDetailModel messageBoardDetailModel;

  Loaded({required this.messageBoardDetailModel});

  @override
  List<Object> get props => [messageBoardDetailModel];
}

class CarRemoved extends MessageBoardState {
  final String messageCode;
  final String messageContent;

  CarRemoved({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class Error extends MessageBoardState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends MessageBoardState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class FavoriteUpdated extends MessageBoardState {
  final bool isChecked;

  FavoriteUpdated({
    required this.isChecked,
  });
}

class SentComment extends MessageBoardState {}

class DeletedRemotePhotos extends MessageBoardState {}

class UpdatedPhotos extends MessageBoardState {
  final DateTime updatedTime;

  UpdatedPhotos() : this.updatedTime = DateTime.now();

  @override
  List<Object> get props => [this.updatedTime];
}
