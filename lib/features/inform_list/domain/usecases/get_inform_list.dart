import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_request.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_response.dart';
import 'package:mirukuru/features/inform_list/domain/repositories/inform_list_repository.dart';

import '../../../../core/error/error_model.dart';

class GetInformList
    implements
        UseCaseExtend<List<InformListResponseModel>?, InformListRequestModel> {
  final InformListRepository repository;

  GetInformList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<InformListResponseModel>?>> call(
      InformListRequestModel params) {
    return repository.getInformList(params);
  }
}
