import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_detail/domain/repositories/search_detail_repository.dart';

class DeleteFavoriteSearchDetail
    implements UseCaseExtend<void, ParamDeleteFavoriteSearchDetailRequests> {
  final SearchDetailRepository repository;

  DeleteFavoriteSearchDetail(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamDeleteFavoriteSearchDetailRequests param) async {
    return await repository.deleteFavoriteObjectListByPosition(
        param.tableName, param.questionNo);
  }
}

class ParamDeleteFavoriteSearchDetailRequests extends Equatable {
  final String tableName;
  final String questionNo;

  ParamDeleteFavoriteSearchDetailRequests(
      {required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [tableName, questionNo];
}
