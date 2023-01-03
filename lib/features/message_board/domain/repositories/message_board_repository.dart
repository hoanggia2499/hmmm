import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_list_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_model.dart';
import 'package:mirukuru/features/message_board/data/models/new_comment_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_request_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/number_of_quotation_request.dart';
import '../../../../core/error/error_model.dart';

abstract class MessageBoardRepository {
  Future<Either<ReponseErrorModel, MessageBoardDetailModel>>
      getMessageBoardDetail(MessageBoardDetailRequestModel request);
  Future<Either<ReponseErrorModel, AsnetCarDetailModel?>> getAsnetCarDetail(
      AsnetCarDetailRequestModel request);
  Future<Either<ReponseErrorModel, OwnCarDetailModel?>> getOwnCarDetail(
      OwnCarDetailRequestModel request);
  Future<Either<ReponseErrorModel, List<CommentModel>?>> getCommentList(
      CommentListRequestModel request);
  Future<Either<ReponseErrorModel, String>> postNewComment(
      NewCommentRequestModel request);
  Future<Either<ReponseErrorModel, int?>> getNumberOfQuotationToday(
      NumberOfQuotationRequestModel request);
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getFavoriteList(
      String tableName, Map<String, String> pic1Map);
  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo);
  Future<Either<ReponseErrorModel, void>> addFavorite(
      ItemSearchModel item, String tableName, String questionNo);
  Future<Either<ReponseErrorModel, String>> getColorName(String colorCode);
}
