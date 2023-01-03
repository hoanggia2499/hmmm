import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/quotation/domain/repositories/quotation_repository.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class GetFavoriteListQuotation
    implements
        UseCaseExtend<List<ItemSearchModel>,
            ParamGetFavoriteListQuotationRequests> {
  final QuotationRepository repository;

  GetFavoriteListQuotation(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> call(
      ParamGetFavoriteListQuotationRequests param) async {
    return await repository.getFavoriteList(param.tableName, param.pic1Map);
  }
}

class ParamGetFavoriteListQuotationRequests extends Equatable {
  final String tableName;
  final Map<String, String> pic1Map;

  ParamGetFavoriteListQuotationRequests(
      {required this.tableName, required this.pic1Map});

  @override
  List<Object> get props => [tableName, pic1Map];
}
