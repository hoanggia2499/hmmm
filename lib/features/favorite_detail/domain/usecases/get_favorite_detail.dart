import 'package:dartz/dartz.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/favorite_detail_repository.dart';

class GetFavoriteDetail
    implements UseCaseExtend<List<SearchCarModel>, SearchCarInputModel> {
  final FavoriteDetailRepository repository;

  GetFavoriteDetail(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> call(
      SearchCarInputModel params) async {
    return await repository.getFavoriteDetail(params);
  }
}
