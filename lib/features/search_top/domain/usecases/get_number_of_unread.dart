import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/features/search_top/domain/repositories/search_top_repository.dart';

import '../../../../core/error/error_model.dart';
import '../../../../core/usecases/usecase_extend.dart';

class GetNumberOfUnread implements UseCaseExtend<int, ParamRequests> {
  final SearchTopRepository repository;

  GetNumberOfUnread(this.repository);

  @override
  Future<Either<ReponseErrorModel, int>> call(ParamRequests params) async {
    return await repository.getNumberOfUnread(params.memberNum, params.userNum);
  }
}

class ParamRequests extends Equatable {
  final String memberNum;
  final int userNum;

  ParamRequests({required this.memberNum, required this.userNum});

  @override
  List<Object> get props => [memberNum, userNum];
}
