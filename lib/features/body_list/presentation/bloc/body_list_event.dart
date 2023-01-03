import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/db/car_search_hive.dart';

abstract class BodyListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BodyListInit extends BodyListEvent {}

class GetBodyListEvent extends BodyListEvent {
  GetBodyListEvent(this.id, this.context);

  final int id;
  final BuildContext context;
  @override
  List<Object> get props => [id, context];
}

class AddAllCarListEvent extends BodyListEvent {
  AddAllCarListEvent(
    this.carSearchList,
    this.tableName,
  );

  final List<CarSearchHive> carSearchList;
  final String tableName;

  @override
  List<Object> get props => [carSearchList, tableName];
}
