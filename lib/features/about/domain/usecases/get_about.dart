import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/about/domain/repositories/about_repository.dart';

import '../../../../core/error/error_model.dart';

class GetAbout implements UseCaseExtend<String, NoParamsExt> {
  final AboutRepository repository;

  GetAbout(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(NoParamsExt params) async {
    return await repository.getAbout();
  }
}
