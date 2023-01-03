import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';

abstract class CarListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CarListInit extends CarListEvent {}

class GetCarListEvent extends CarListEvent {
  GetCarListEvent(this.caller, this.context, this.makerCode);

  final String caller;
  final BuildContext context;
  final String makerCode;
  @override
  List<Object> get props => [caller, context, makerCode];
}

class AddAllCarListEvent extends CarListEvent {
  AddAllCarListEvent(
    this.carSearchList,
    this.tableName,
  );

  final List<CarSearchHive> carSearchList;
  final String tableName;

  @override
  List<Object> get props => [carSearchList, tableName];
}

class DeleteCarListEvent extends CarListEvent {
  DeleteCarListEvent(
    this.tableName,
  );

  final String tableName;

  @override
  List<Object> get props => [tableName];
}
