import 'package:equatable/equatable.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_model.dart';

class MessageBoardDetailModel extends Equatable {
  AsnetCarDetailModel? asnetCarDetailModel;
  OwnCarDetailModel? ownCarDetailModel;
  List<CommentModel>? commentList;
  List<String>? images;

  MessageBoardDetailModel({
    this.asnetCarDetailModel,
    this.ownCarDetailModel,
    this.commentList,
    this.images,
  });

  @override
  List<Object?> get props => [
        this.asnetCarDetailModel,
        this.ownCarDetailModel,
        this.commentList,
        this.images
      ];
}
