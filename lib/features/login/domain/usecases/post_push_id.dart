import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';
import '../repositories/login_repository.dart';

class PostPushId implements UseCaseExtend<String, ParamPushId> {
  final LoginRepository repository;

  PostPushId(this.repository);

  @override
  Future<Either<ReponseErrorModel, String>> call(ParamPushId params) async {
    return await repository.postPushId(params.memberNum, params.userNum,
        params.androidPushId, params.iOSPushId, params.deviceType);
  }
}

class ParamPushId extends Equatable {
  final String memberNum;
  final int userNum;
  final String androidPushId;
  final String iOSPushId;
  final int deviceType;
  ParamPushId(
      {required this.memberNum,
      required this.userNum,
      required this.androidPushId,
      required this.iOSPushId,
      required this.deviceType});

  @override
  List<Object> get props =>
      [memberNum, userNum, androidPushId, iOSPushId, deviceType];
}
