import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/message_board/domain/repositories/message_board_repository.dart';

class GetColorName implements UseCaseExtend<String, ParamGetColorNameRequests> {
  final MessageBoardRepository repository;

  GetColorName(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      ParamGetColorNameRequests param) async {
    return await repository.getColorName(param.colorCode);
  }
}

class ParamGetColorNameRequests extends Equatable {
  final String colorCode;

  ParamGetColorNameRequests(
    this.colorCode,
  );

  @override
  List<Object> get props => [colorCode];
}
