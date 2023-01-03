import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/quotation/domain/repositories/quotation_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class AddFavoriteQuotation
    implements UseCaseExtend<void, ParamAddFavoriteQuotationRequests> {
  final QuotationRepository repository;

  AddFavoriteQuotation(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamAddFavoriteQuotationRequests param) async {
    return await repository.addFavorite(
        param.item, param.tableName, param.questionNo);
  }
}

class ParamAddFavoriteQuotationRequests extends Equatable {
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  ParamAddFavoriteQuotationRequests(this.item,
      {required this.tableName, required this.questionNo});

  @override
  List<Object> get props => [tableName, questionNo, item];
}
