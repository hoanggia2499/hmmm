import 'package:mirukuru/core/error/error_model.dart';
import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/message_board/data/models/new_comment_request_model.dart';
import 'package:mirukuru/features/message_board/domain/repositories/message_board_repository.dart';

class SendNewComment extends UseCaseExtend<String, NewCommentRequestModel> {
  final MessageBoardRepository repository;

  SendNewComment(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      NewCommentRequestModel params) async {
    return await repository.postNewComment(params);
  }
}
