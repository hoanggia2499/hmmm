import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_reponse_model.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_request_model.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/invite_repository.dart';

class InviteFriend
    implements
        UseCaseExtend<InviteFriendResponseModel?, InviteFriendRequestModel> {
  final InviteRepository repository;

  InviteFriend(this.repository);

  @override
  Future<Either<ReponseErrorModel, InviteFriendResponseModel?>> call(
      InviteFriendRequestModel params) {
    return repository.inviteFriend(params);
  }
}
