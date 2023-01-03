import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_request.dart';
import 'package:mirukuru/features/inform_detail/data/models/carSP_response.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/util/connection_util.dart';
import '../../../../core/util/error_code.dart';
import '../../domain/repositories/inform_detail_repository.dart';
import '../datasources/inform_detail_remote_data_souce.dart';
import '../models/inform_detail_request.dart';

class InformDetailRepositoryImpl implements InformDetailRepository {
  final InformDetailRemoteDataSource dataSource;

  InformDetailRepositoryImpl({required this.dataSource});

  @override
  Future<Either<ReponseErrorModel, String?>> getInformList(
      InformDetailRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getFormList(request);
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

  @override
  Future<Either<ReponseErrorModel, CarSPResponseModel?>> moveToCarDetail(
      CarSPRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getCarSP(request);
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
