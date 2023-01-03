import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/history/domain/repositories/history_repository.dart';

class DeleteFavoriteByPositionHistory
    implements UseCaseExtend<void, ParamDeleteFavoriteRequests> {
  final HistoryRepository repository;

  DeleteFavoriteByPositionHistory(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamDeleteFavoriteRequests param) async {
    return await repository.deleteFavoriteObjectListByPosition(
        param.tableName, param.questionNo);
  }
}

class ParamDeleteFavoriteRequests extends Equatable {
  final String tableName;
  final String questionNo;

  ParamDeleteFavoriteRequests(
      {required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [tableName, questionNo];
}
