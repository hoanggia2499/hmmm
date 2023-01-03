import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

class AddSearch implements UseCaseExtend<void, ParamAddSearchRequests> {
  final SearchListRepository repository;

  AddSearch(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamAddSearchRequests param) async {
    return await repository.addSearchHistoryObjectList(
        param.element, param.tableName);
  }
}

class ParamAddSearchRequests extends Equatable {
  final SearchListModel element;
  final String tableName;
  ParamAddSearchRequests({required this.element, required this.tableName});

  @override
  List<Object> get props => [element, tableName];
}
