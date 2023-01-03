import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/inform_list/data/datasources/inform_list_remote_data_souce.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_request.dart';
import 'package:mirukuru/features/inform_list/data/models/inform_list_response.dart';
import 'package:mirukuru/features/inform_list/domain/repositories/inform_list_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/util/connection_util.dart';
import '../../../../core/util/error_code.dart';

class InformListRepositoryImpl implements InformListRepository {
  final InformListRemoteDataSource dataSource;

  InformListRepositoryImpl({required this.dataSource});

  @override
  Future<Either<ReponseErrorModel, List<InformListResponseModel>?>>
      getInformList(InformListRequestModel request) async {
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
}
