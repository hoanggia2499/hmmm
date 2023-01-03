import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_request.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_response.dart';

import '../../data/models/inform_detail_request.dart';

abstract class InformDetailRepository {
  Future<Either<ReponseErrorModel, String?>> getInformList(
      InformDetailRequestModel request);

  Future<Either<ReponseErrorModel, CarSPResponseModel?>> moveToCarDetail(
      CarSPRequestModel request);
}
