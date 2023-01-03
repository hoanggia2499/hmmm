import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/quotation/data/datasources/quotation_local_data_source.dart';
import 'package:mirukuru/features/quotation/data/datasources/quotation_remote_data_source.dart';
import 'package:mirukuru/features/quotation/data/models/inquiry_request_model.dart';
import 'package:mirukuru/features/quotation/domain/repositories/quotation_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../../../core/error/exceptions.dart';

class QuotationRepositoryImpl implements QuotationRepository {
  final QuotationDataSource quotationDataSource;
  final QuotationLocalDataSource quotationLocalDataSource;
  QuotationRepositoryImpl({
    required this.quotationDataSource,
    required this.quotationLocalDataSource,
  });

  @override
  Future<Either<ReponseErrorModel, String>> getQuotation() async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await quotationDataSource.getQuotation();
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

  @override
  Future<Either<ReponseErrorModel, String>> makeAnInquiry(
      InquiryRequestModel quotationRequest) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await quotationDataSource.makeAnInquiry(quotationRequest);
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

  @override
  Future<Either<ReponseErrorModel, List<SearchCarModel>>> getSeachDetail(
      SearchCarInputModel searchCarInputModel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await quotationDataSource.getSeachDetail(searchCarInputModel);
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

  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getFavoriteList(
      String tableName, Map<String, String> pic1Map) async {
    try {
      var result =
          await quotationLocalDataSource.getFavoriteList(tableName, pic1Map);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> deleteFavoriteObjectListByPosition(
      String tableName, String questionNo) async {
    try {
      var result = await quotationLocalDataSource
          .deleteFavoriteObjectListByPosition(tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, void>> addFavorite(
      ItemSearchModel item, String tableName, String questionNo) async {
    try {
      var result = await quotationLocalDataSource.addFavorite(
          item, tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
