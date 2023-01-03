import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_reponse_model.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_request_model.dart';
import '../../../../core/error/error_model.dart';

abstract class InviteRepository {
  Future<Either<ReponseErrorModel, InviteFriendResponseModel?>> inviteFriend(
      InviteFriendRequestModel request);
}
