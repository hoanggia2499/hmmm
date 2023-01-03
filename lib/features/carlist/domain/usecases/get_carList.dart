import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mirukuru/core/error/error_model.dart';
import 'package:mirukuru/core/usecases/usecase_extend.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/carlist/domain/repositories/carList_repository.dart';

class GetCarList
    implements UseCaseExtend<List<CarModel>, ParamCarListRequests> {
  final CarListRepository repository;

  GetCarList(this.repository);

  @override
  Future<Either<ReponseErrorModel, List<CarModel>>> call(
      ParamCarListRequests param) async {
    return await repository.getCarList(param);
  }
}

class ParamCarListRequests extends Equatable {
  final String makerCode;
  final String caller;

  ParamCarListRequests({required this.makerCode, required this.caller});

  @override
  List<Object> get props => [makerCode, caller];
}
