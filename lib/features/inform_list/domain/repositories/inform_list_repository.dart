import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';

import '../../data/models/inform_list_request.dart';
import '../../data/models/inform_list_response.dart';

abstract class InformListRepository {
  Future<Either<ReponseErrorModel, List<InformListResponseModel>?>>
      getInformList(InformListRequestModel request);
}
