import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/search_top/domain/repositories/search_top_repository.dart';

import '../../data/models/name_model.dart';

class GetName implements UseCaseExtend<NameModel?, NoParamsExt> {
  final SearchTopRepository repository;

  GetName(this.repository);

  @override
  Future<Either<ReponseErrorModel, NameModel?>> call(NoParamsExt params) async {
    return await repository.getName();
  }
}
