import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/store_information/data/models/store_information_model.dart';
import 'package:mirukuru/features/store_information/domain/repositories/store_repository.dart';

class GetStoreInformation
    implements UseCaseExtend<StoreInformationModel?, String> {
  final StoreRepository repository;

  GetStoreInformation(this.repository);

  @override
  Future<Either<ReponseErrorModel, StoreInformationModel?>> call(
      String params) {
    return repository.getStoreInformation(params);
  }
}
