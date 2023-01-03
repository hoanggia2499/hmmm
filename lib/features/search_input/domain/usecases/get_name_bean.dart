import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/db/name_bean_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_input/domain/repositories/search_input_repository.dart';

class GetNameBeanFavorite
    implements UseCaseExtend<List<NameBeanHive>, ParamNameBeanRequests> {
  final SearchInputRepository repository;

  GetNameBeanFavorite(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<NameBeanHive>>> call(
      ParamNameBeanRequests param) async {
    return await repository.getNameBeanFromHiveDb(param.tableName);
  }
}

class ParamNameBeanRequests extends Equatable {
  final String tableName;
  ParamNameBeanRequests({
    required this.tableName,
  });

  @override
  List<Object> get props => [tableName];
}
