import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/favorite_list/domain/repositories/favorite_list_repository.dart';

class RemoveCarSeenFavoriteList
    implements UseCaseExtend<void, ParamRemoveCarSeenFavoriteListRequests> {
  final FavoriteListRepository repository;

  RemoveCarSeenFavoriteList(this.repository);

  @override
  Future<Either<ReponseErrorModel, void>> call(
      ParamRemoveCarSeenFavoriteListRequests param) async {
    return await repository.removeCarObjectList(
        param.tableName, param.indexRemove);
  }
}

class ParamRemoveCarSeenFavoriteListRequests extends Equatable {
  final String tableName;
  final int indexRemove;

  ParamRemoveCarSeenFavoriteListRequests(this.tableName, this.indexRemove);

  @override
  List<Object> get props => [tableName, indexRemove];
}
