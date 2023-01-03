import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/db/user_car_list_hive.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/error_code.dart';
import 'package:mirukuru/features/my_page/data/datasources/my_page_local_data_source.dart';
import 'package:mirukuru/features/my_page/data/datasources/my_page_remote_data_source.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_request_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_update_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_user_car_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_request_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_model.dart';
import 'package:mirukuru/features/my_page/domain/repositories/my_page_repository.dart';

import '../../../../core/error/exceptions.dart';

class MyPageRepositoryImpl implements MyPageRepository {
  final MyPageDataSource dataSource;
  final MyPageLocalDataSource localDataSource;
  const MyPageRepositoryImpl(
      {required this.dataSource, required this.localDataSource});

  @override
  Future<Either<ReponseErrorModel, String>> saveMyPageInformation(
      MyPageUpdateModel inputModel) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.saveMyPageInformation(inputModel);
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
  Future<Either<ReponseErrorModel, MyPageModel?>> getMyPageInformation(
      MyPageRequestModel request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getMyPageInformation(request);
        addUserCarToHiveDb(result!.userCarList ?? [], result.mobilePhone);
        Logging.log.info("save hive db success");
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
  Future<Either<ReponseErrorModel, List<UserCarNameModel>?>> getUserCaNameList(
      List<UserCarNameRequestModel> request) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await dataSource.getUserCarNameList(request);
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

  addUserCarToHiveDb(
      List<UserCarModel> responseSuccess, String mobilePhone) async {
    var userCarHiveList = <UserCarHive>[];
    responseSuccess.forEach((element) {
      userCarHiveList.add(UserCarHive(
          memberNum: element.memberNum,
          userNum: element.userNum,
          userCarNum: element.userCarNum,
          carGrade: element.carGrade,
          plateNo1: element.plateNo1,
          plateNo2: element.plateNo2,
          plateNo3: element.plateNo3,
          plateNo4: element.plateNo4,
          makerCode: element.makerCode,
          carCode: element.carCode,
          nHokenInc: element.nHokenInc,
          carModel: element.carModel,
          sellTime: element.sellTime,
          inspectionDate: element.inspectionDate,
          nHokenEndDay: element.nHokenEndDay,
          colorName: element.colorName,
          mileage: element.mileage));
    });
    await localDataSource.addAllUserCar(
        userCarHiveList, mobilePhone, Constants.USER_CAR_TABLE);
  }
}
