import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_request_model.dart';
import 'package:mirukuru/features/message_board/domain/repositories/message_board_repository.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';

class GetMessageBoard
    implements
        UseCaseExtend<MessageBoardDetailModel, MessageBoardDetailRequestModel> {
  final MessageBoardRepository repository;

  GetMessageBoard(this.repository);

  @override
  Future<Either<ReponseErrorModel, MessageBoardDetailModel>> call(
      MessageBoardDetailRequestModel request) async {
    return await repository.getMessageBoardDetail(request);
  }
}
