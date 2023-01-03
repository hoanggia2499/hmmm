import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/network/dio_base.dart';
import 'package:mirukuru/core/network/task_type.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_reponse_model.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_request_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class InviteDataSource {
  Future<InviteFriendResponseModel?> inviteFriend(
      InviteFriendRequestModel request);
}

class InviteDataSourceImpl implements InviteDataSource {
  InviteDataSourceImpl();

  @override
  Future<InviteFriendResponseModel?> inviteFriend(
      InviteFriendRequestModel request) async {
    String url = Common.apiPostInviteFriend;

    final response = await BaseDio.instance
        .post<InviteFriendResponseModel?>(url, data: request.toMap());

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
