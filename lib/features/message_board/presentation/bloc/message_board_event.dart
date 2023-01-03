import 'package:equatable/equatable.dart';

import 'package:mirukuru/features/message_board/data/models/delele_single_photo_request.model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/new_comment_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/upload_photo_request_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

abstract class MessageBoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MessageBoardInit extends MessageBoardEvent {
  final MessageBoardDetailRequestModel request;

  MessageBoardInit(this.request);
}

class MessageBoardFavoriteClicked extends MessageBoardEvent {
  final ItemSearchModel itemSearchModel;

  MessageBoardFavoriteClicked(this.itemSearchModel);
}

class MessageBoardSendComment extends MessageBoardEvent {
  final NewCommentRequestModel request;
  final List<DeleteSinglePhotoRequestModel>? deleteRemotePhotoRequest;
  final PhotoUploadRequestModel? uploadPhotoRequestModel;

  MessageBoardSendComment(
      {required this.request,
      this.deleteRemotePhotoRequest,
      this.uploadPhotoRequestModel});

  @override
  List<Object> get props => [request];
}

class MessageBoardDeletePhoto extends MessageBoardEvent {
  final List<DeleteSinglePhotoRequestModel> request;
  final PhotoUploadRequestModel? uploadPhotoRequestModel;

  MessageBoardDeletePhoto(this.request, this.uploadPhotoRequestModel);

  @override
  List<Object> get props => [request];
}

class MessageBoardUploadPhoto extends MessageBoardEvent {
  final PhotoUploadRequestModel request;

  MessageBoardUploadPhoto(this.request);

  @override
  List<Object> get props => [request];
}

class MessageBoardUpdatePhoto extends MessageBoardEvent {
  @override
  List<Object> get props => super.props;
}

class AddFavoriteEvent extends MessageBoardEvent {
  AddFavoriteEvent(this.item, this.tableName, this.questionNo);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  @override
  List<Object> get props => [item, tableName, questionNo];
}
