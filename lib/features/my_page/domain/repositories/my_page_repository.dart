import 'package:dartz/dartz.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_request_model.dart';
import 'package:mirukuru/features/my_page/data/models/my_page_update_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_model.dart';
import 'package:mirukuru/features/my_page/data/models/user_car_name_request_model.dart';

abstract class MyPageRepository {
  Future<Either<ReponseErrorModel, MyPageModel?>> getMyPageInformation(
      MyPageRequestModel request);
  Future<Either<ReponseErrorModel, String>> saveMyPageInformation(
      MyPageUpdateModel inputModel);
  Future<Either<ReponseErrorModel, List<UserCarNameModel>?>> getUserCaNameList(
      List<UserCarNameRequestModel> request);
}
