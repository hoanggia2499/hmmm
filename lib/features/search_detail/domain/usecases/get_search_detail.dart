import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/search_detail_repository.dart';

class GetSeachDetail
    implements UseCaseExtend<List<SearchCarModel>, SearchCarInputModel> {
  final SearchDetailRepository repository;

  GetSeachDetail(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> call(
      SearchCarInputModel params) async {
    return await repository.getSeachDetail(params);
  }
}
