import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

class UpdateSearch implements UseCaseExtend<void, ParamUpdateSearchRequests> {
  final SearchListRepository repository;

  UpdateSearch(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamUpdateSearchRequests param) async {
    return await repository.updateSearchHistoryObjectList(
        param.index, param.tableName);
  }
}

class ParamUpdateSearchRequests extends Equatable {
  final int index;
  final String tableName;

  ParamUpdateSearchRequests({required this.index, required this.tableName});

  @override
  List<Object> get props => [index, tableName];
}
