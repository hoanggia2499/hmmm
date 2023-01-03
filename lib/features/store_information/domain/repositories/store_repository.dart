import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/store_information/data/models/store_information_model.dart';

abstract class StoreRepository {
  Future<Either<ReponseErrorModel, StoreInformationModel?>> getStoreInformation(
      String memberNum);
}
