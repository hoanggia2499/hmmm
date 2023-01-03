import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/favorite_list/domain/repositories/favorite_list_repository.dart';

import '../../../../core/error/error_model.dart';

class GetFavoriteList implements UseCaseExtend<String, NoParamsExt> {
  final FavoriteListRepository repository;

  GetFavoriteList(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(NoParamsExt params) async {
    return await repository.getFavoriteList();
  }
}
