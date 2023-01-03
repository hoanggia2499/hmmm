import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';

abstract class MakerListRepository {
  Future<Either<ReponseErrorModel, List<ItemMakerModel>>> getMakerList();
}
