import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';
import 'package:mirukuru/features/body_list/domain/repositories/body_list_repository.dart';

class GetBodyList implements UseCaseExtend<List<BodyModel>, int> {
  final BodyListRepository repository;

  GetBodyList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<BodyModel>>> call(int params) async {
    return await repository.getBodyList(params);
  }
}
