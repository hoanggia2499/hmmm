import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_reponse_model.dart';
import 'package:mirukuru/features/invite/data/models/invite_friend_request_model.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/invite_repository.dart';
import '../datasources/invite_remote_data_source.dart';

class InviteRepositoryImpl implements InviteRepository {
  final InviteDataSource dataSource;

  InviteRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<ReponseErrorModel, InviteFriendResponseModel?>> inviteFriend(
      InviteFriendRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.inviteFriend(request);
        return Right(result);
      } on ServerException catch (error) {
        return Left(
            ReponseErrorModel(msgCode: error.code, msgContent: error.content));
      } on Exception {
        return Left(ReponseErrorModel(
            msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
      }
    } else {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
    }
  }
}
