import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';

import '../../../../core/error/error_model.dart';
import '../../data/models/inform_detail_request.dart';
import '../repositories/inform_detail_repository.dart';

class UpdateStatusInform
    implements UseCaseExtend<String?, InformDetailRequestModel> {
  final InformDetailRepository repository;

  UpdateStatusInform(this.repository);

  @override
  Future<Either<ReponseErrorModel, String?>> call(
      InformDetailRequestModel params) {
    return repository.getInformList(params);
  }
}
