import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/error/exceptions.dart';
import 'package:mirukuru/core/util/connection_util.dart';
import '../../../../core/db/name_bean_hive.dart';
import '../../../../core/db/rikuji_bean_hive.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/error_code.dart';
import '../../domain/repositories/search_top_repository.dart';
import '../../../search_top/data/models/company_get_model.dart';
import '../datasources/search_top_local_data_source.dart';
import '../datasources/search_top_remote_data_source.dart';
import '../models/name_model.dart';

class SearchTopRepositoryImpl implements SearchTopRepository {
  final SearchTopRemoteDataSource topRemoteDataSource;
  final SearchTopLocalDataSource topLocalDataSource;

  SearchTopRepositoryImpl({
    required this.topRemoteDataSource,
    required this.topLocalDataSource,
  });

  // onNameInit in bloc
  @override
  Future<Either<ReponseErrorModel, NameModel?>> getName() async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await topRemoteDataSource.getName();
        // Save data to DB
        if (result != null) {
          await Future.wait([
            topLocalDataSource.deleteDropDownList(Constants.NAME_BEAN_TABLE),
            topLocalDataSource.deleteDropDownList(Constants.RIKUJI_BEAN_TABLE),
          ]);
          addNameBeanAndRikujiToHiveDb(result);
        }
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

  Future<Either<ReponseErrorModel, int>> getNumberOfUnread(
      String memberNum, int userNum) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result =
            await topRemoteDataSource.getNumberOfUnread(memberNum, userNum);
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

  Future<Either<ReponseErrorModel, CompanyGetModel>> companyGet(
      String memberNum) async {
    if (await InternetConnection.instance.isHasConnection()) {
      try {
        var result = await topRemoteDataSource.companyGet(memberNum);
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

  addNameBeanAndRikujiToHiveDb(NameModel responseSuccess) async {
    var nameBeanHiveList = <NameBeanHive>[];
    responseSuccess.nameList.forEach((element) {
      nameBeanHiveList.add(NameBeanHive(
          name: element.name,
          nameCode: element.nameCode,
          nameKbn: element.nameKbn));
    });
    await topLocalDataSource.addAllNameBean(
        nameBeanHiveList, Constants.NAME_BEAN_TABLE);

    var rikujiBeanHiveList = <RikujiBeanHive>[];
    responseSuccess.rikujiList.forEach((element) {
      rikujiBeanHiveList.add(RikujiBeanHive(
          prefName: element.prefName,
          nameKbn: element.nameKbn,
          nameCode: element.nameCode));
    });

    await topLocalDataSource.addAllRikujiBean(
        rikujiBeanHiveList, Constants.RIKUJI_BEAN_TABLE);
  }
}
