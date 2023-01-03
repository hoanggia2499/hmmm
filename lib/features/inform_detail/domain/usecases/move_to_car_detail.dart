import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_request.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_response.dart';

import '../../../../core/error/error_model.dart';
import '../repositories/inform_detail_repository.dart';

class MoveToCarDetail
    implements UseCaseExtend<CarSPResponseModel?, CarSPRequestModel> {
  final InformDetailRepository repository;

  MoveToCarDetail(this.repository);

  @override
  Future<Either<ReponseErrorModel, CarSPResponseModel?>> call(
      CarSPRequestModel params) {
    return repository.moveToCarDetail(params);
  }
}
