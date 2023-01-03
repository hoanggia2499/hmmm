import 'package:dartz/dartz.dart';
import '../../../../core/error/error_model.dart';
import '../../../search_top/data/models/company_get_model.dart';
import '../../data/models/name_model.dart';

abstract class SearchTopRepository {
  Future<Either<ReponseErrorModel, NameModel?>> getName();

  Future<Either<ReponseErrorModel, int>> getNumberOfUnread(
      String memberNum, int userNum);

  Future<Either<ReponseErrorModel, CompanyGetModel>> companyGet(
      String memberNum);
}
