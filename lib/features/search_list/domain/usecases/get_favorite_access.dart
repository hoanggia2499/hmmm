import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/domain/repositories/search_list_repository.dart';

class GetFavoriteAccess implements UseCaseExtend<String, FavoriteAccessModel> {
  final SearchListRepository repository;

  GetFavoriteAccess(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      FavoriteAccessModel params) async {
    return await repository.getFavoriteAccess(params);
  }
}
