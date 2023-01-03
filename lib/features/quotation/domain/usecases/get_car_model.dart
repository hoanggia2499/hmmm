import 'package:dartz/dartz.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../../../search_detail/data/models/search_car_input_model.dart';
import '../../../search_detail/data/models/search_car_model.dart';
import '../repositories/quotation_repository.dart';

class GetCarDetail
    implements UseCaseExtend<List<SearchCarModel>, SearchCarInputModel> {
  final QuotationRepository repository;

  GetCarDetail(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> call(
      SearchCarInputModel params) async {
    return await repository.getSeachDetail(params);
  }
}
