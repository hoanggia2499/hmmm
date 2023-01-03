import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/history/domain/repositories/history_repository.dart';

import '../../../search_list/data/models/favorite_access_model.dart';

class GetFavoriteHistoryAccess
    implements UseCaseExtend<String, FavoriteAccessModel> {
  final HistoryRepository repository;

  GetFavoriteHistoryAccess(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      FavoriteAccessModel params) async {
    return await repository.getFavoriteAccess(params);
  }
}
