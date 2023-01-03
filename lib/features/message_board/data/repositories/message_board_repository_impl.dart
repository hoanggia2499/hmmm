import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/core/util/future_util.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/features/message_board/data/datasources/message_board_local_data_source.dart';
import 'package:mirukuru/features/message_board/data/datasources/photo_remote_data_source.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/asnetcar_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/new_comment_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/own_car_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_model.dart';
import 'package:mirukuru/features/message_board/data/models/comment_list_request_model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_model.dart';
import 'package:mirukuru/features/message_board/data/models/message_board_detail_request_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/number_of_quotation_request.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/message_board_repository.dart';
import '../datasources/message_board_remote_data_source.dart';

class MessageBoardRepositoryImpl implements MessageBoardRepository {
  final MessageBoardRemoteDataSource dataSource;
  final PhotoRemoteDataSource photoRemoteDataSource;
  final MessageBoardLocalDataSource messageBoardLocalDataSource;
  MessageBoardRepositoryImpl(
      {required this.photoRemoteDataSource,
      required this.dataSource,
      required this.messageBoardLocalDataSource});

  @override
  Future<Either<ReponseErrorModel, AsnetCarDetailModel?>> getAsnetCarDetail(
      AsnetCarDetailRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getAsnetCarDetail(request);
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
  Future<Either<ReponseErrorModel, List<CommentModel>?>> getCommentList(
      CommentListRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getCommentList(request);
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
  Future<Either<ReponseErrorModel, OwnCarDetailModel?>> getOwnCarDetail(
      OwnCarDetailRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getOwnCarDetail(request);
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
  Future<Either<ReponseErrorModel, MessageBoardDetailModel>>
      getMessageBoardDetail(MessageBoardDetailRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        if (request.asnetCarDetailRequestModel != null) {
          var result = await FutureUtil.waitConcurrentFuture2(
              dataSource.getCommentList(request.commentListRequestModel),
              dataSource
                  .getAsnetCarDetail(request.asnetCarDetailRequestModel!));

          var quotationDetailModel = MessageBoardDetailModel(
            asnetCarDetailModel: result.value2,
            commentList: result.value1,
          );

          return Right(quotationDetailModel);
        } else {
          var quotationDetailModel;
          if (request.ownCarDetailRequestModel?.userCarNum == "0") {
            var result = await FutureUtil.waitConcurrentFuture2(
                dataSource.getCommentList(request.commentListRequestModel),
                photoRemoteDataSource.getPhotos(request.getImageRequestModel!));

            quotationDetailModel = MessageBoardDetailModel(
                commentList: result.value1,
                images: result.value2,
                ownCarDetailModel: OwnCarDetailModel.undefined());
          } else {
            var result = await FutureUtil.waitConcurrentFuture3(
                dataSource.getCommentList(request.commentListRequestModel),
                dataSource.getOwnCarDetail(request.ownCarDetailRequestModel!),
                photoRemoteDataSource.getPhotos(request.getImageRequestModel!));

            quotationDetailModel = MessageBoardDetailModel(
                ownCarDetailModel: result.value2,
                commentList: result.value1,
                images: result.value3);
          }

          return Right(quotationDetailModel);
        }
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
  Future<Either<ReponseErrorModel, String>> postNewComment(
      NewCommentRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.postNewComment(request);
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
  Future<Either<ReponseErrorModel, int?>> getNumberOfQuotationToday(
      NumberOfQuotationRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getNumberOfQuotationToday(request);
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

  Future<Either<ReponseErrorModel, List<ItemSearchModel>>> getFavoriteList(
      String tableName, Map<String, String> pic1Map) async {
    try {
      var result =
          await messageBoardLocalDataSource.getFavoriteList(tableName, pic1Map);
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
      var result = await messageBoardLocalDataSource
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
      var result = await messageBoardLocalDataSource.addFavorite(
          item, tableName, questionNo);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }

  Future<Either<ReponseErrorModel, String>> getColorName(
      String colorCode) async {
    try {
      var result = await messageBoardLocalDataSource.getColorName(colorCode);
      return Right(result);
    } on Exception catch (ex) {
      Logging.log.debug(ex);
      return Left(ReponseErrorModel(
          msgCode: ErrorCode.MA013CE, msgContent: ErrorCode.MA013CE.tr()));
    }
  }
}
