import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_list_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/get_image_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_request_model.dart';

class MessageBoardDetailRequestModel {
  final AsnetCarDetailRequestModel? asnetCarDetailRequestModel;
  final OwnCarDetailRequestModel? ownCarDetailRequestModel;
  final CommentListRequestModel commentListRequestModel;
  final GetImageRequestModel? getImageRequestModel;

  MessageBoardDetailRequestModel({
    this.asnetCarDetailRequestModel,
    this.ownCarDetailRequestModel,
    required this.commentListRequestModel,
    this.getImageRequestModel,
  }) {
    assert(
        this.asnetCarDetailRequestModel == null ||
            this.ownCarDetailRequestModel == null,
        "QuotationDetailRequest must contain either AsnetCarDetailRequestModel or OwnCarDetailRequestModel object");
  }
}
