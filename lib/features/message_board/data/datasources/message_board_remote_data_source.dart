import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_list_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_model.dart';
import 'package:mirukuru/features/message_board/data/models/new_comment_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_request_model.dart';
import 'package:mirukuru/features/search_list/data/models/number_of_quotation_request.dart';
import '../../../../core/error/exceptions.dart';

abstract class MessageBoardRemoteDataSource {
  Future<AsnetCarDetailModel?> getAsnetCarDetail(
      AsnetCarDetailRequestModel request);
  Future<OwnCarDetailModel?> getOwnCarDetail(OwnCarDetailRequestModel request);
  Future<List<CommentModel>?> getCommentList(CommentListRequestModel request);
  Future<int?> getNumberOfQuotationToday(NumberOfQuotationRequestModel request);
  Future<String> postNewComment(NewCommentRequestModel request);
}

class MessageBoardRemoteDataSourceImpl implements MessageBoardRemoteDataSource {
  MessageBoardRemoteDataSourceImpl();

  @override
  Future<AsnetCarDetailModel?> getAsnetCarDetail(
      AsnetCarDetailRequestModel request) async {
    String url = Common.asNetUrl;

    final response = await BaseDio.instance.request<List<AsnetCarDetailModel>>(
        url, MethodType.GET,
        data: request.toMap());

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data?.first;
      default:
        throw ServerException(
          response.messageCode,
          response.messageContent,
        );
    }
  }

  @override
  Future<List<CommentModel>?> getCommentList(
      CommentListRequestModel request) async {
    String url = Common.listCommentsUrl;

    final response = await BaseDio.instance.request<List<CommentModel>>(
        url, MethodType.GET,
        data: request.toMap());

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data;
      default:
        throw ServerException(
          response.messageCode,
          response.messageContent,
        );
    }
  }

  @override
  Future<OwnCarDetailModel?> getOwnCarDetail(
      OwnCarDetailRequestModel request) async {
    String url = Common.apiGetOwnCar;

    final response = await BaseDio.instance
        .request<OwnCarDetailModel>(url, MethodType.GET, data: request.toMap());

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data;
      default:
        throw ServerException(
          response.messageCode,
          response.messageContent,
        );
    }
  }

  @override
  Future<int?> getNumberOfQuotationToday(
      NumberOfQuotationRequestModel request) async {
    String url = Common.apiNumberOfQuotationToday;

    var params = <String, dynamic>{
      'memberNum': request.memberNum,
      'userNum': request.userNum
    };

    final response =
        await BaseDio.instance.request<int>(url, MethodType.GET, data: params);

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data;
      default:
        throw ServerException(
          response.messageCode,
          response.messageContent,
        );
    }
  }

  @override
  Future<String> postNewComment(NewCommentRequestModel request) async {
    String url = Common.commentUrl;

    final response = await BaseDio.instance
        .request(url, MethodType.POST, data: request.toMap());

    switch (response.result) {
      case TaskResult.success:
        if (response.resultStatus != 0) {
          throw ServerException(
            response.messageCode,
            response.messageContent,
          );
        }
        return response.data;
      default:
        throw ServerException(
          response.messageCode,
          response.messageContent,
        );
    }
  }
}
