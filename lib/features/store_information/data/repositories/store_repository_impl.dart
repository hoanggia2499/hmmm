import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/store_information/data/datasources/store_remote_data_source.dart';
import 'package:mirukuru/features/store_information/data/models/store_information_model.dart';
import 'package:mirukuru/features/store_information/domain/repositories/store_repository.dart';

import '../../../../core/error/exceptions.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;

  const StoreRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, StoreInformationModel?>> getStoreInformation(
      String memberNum) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await remoteDataSource.getStoreInformation(memberNum);

        return Right(result);
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
