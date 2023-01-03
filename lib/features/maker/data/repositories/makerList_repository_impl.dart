import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/maker/data/datasources/maker_list_remote_data_source.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';
import 'package:mirukuru/features/maker/domain/repositories/makerList_repository.dart';

import '../../../../core/error/exceptions.dart';

class MakerListRepositoryImpl implements MakerListRepository {
  final MakerListDataSource makerListDataSource;

  MakerListRepositoryImpl({
    required this.makerListDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, List<ItemMakerModel>>> getMakerList() async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await makerListDataSource.getMakerList();
        return Right(result!);
      } on ServerException catch (error) {
        return Left(
            ReponseErrorModel(msgCode: error.code, msgContent: error.content));
      } on Exception {
        return Left(ReponseErrorModel(
            msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
      }
    } else {
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA001CE, msgContent: ErrorCode.MA001CE.tr()));
    }
  }
}
