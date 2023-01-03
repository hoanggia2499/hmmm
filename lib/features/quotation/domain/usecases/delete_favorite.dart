import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/quotation/domain/repositories/quotation_repository.dart';

class DeleteFavoriteQuotation
    implements UseCaseExtend<void, ParamDeleteFavoriteQuotationRequests> {
  final QuotationRepository repository;

  DeleteFavoriteQuotation(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamDeleteFavoriteQuotationRequests param) async {
    return await repository.deleteFavoriteObjectListByPosition(
        param.tableName, param.questionNo);
  }
}

class ParamDeleteFavoriteQuotationRequests extends Equatable {
  final String tableName;
  final String questionNo;

  ParamDeleteFavoriteQuotationRequests(
      {required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [tableName, questionNo];
}
