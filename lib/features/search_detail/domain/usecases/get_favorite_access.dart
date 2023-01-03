import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_detail/domain/repositories/search_detail_repository.dart';

import '../../../search_list/data/models/favorite_access_model.dart';

class GetFavoriteSearchDetailAccess
    implements UseCaseExtend<String, FavoriteAccessModel> {
  final SearchDetailRepository searchDetailRepository;

  GetFavoriteSearchDetailAccess(this.searchDetailRepository);

  @override
  Future<Either<ReponseErrorModel, String>> call(
      FavoriteAccessModel params) async {
    return await searchDetailRepository.getFavoriteAccess(params);
  }
}
