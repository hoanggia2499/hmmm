import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';
import 'package:mirukuru/features/maker/domain/repositories/makerList_repository.dart';

class GetMakerList implements UseCaseExtend<List<ItemMakerModel>, NoParamsExt> {
  final MakerListRepository repository;

  GetMakerList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<ItemMakerModel>>> call(
      NoParamsExt params) async {
    return await repository.getMakerList();
  }
}
