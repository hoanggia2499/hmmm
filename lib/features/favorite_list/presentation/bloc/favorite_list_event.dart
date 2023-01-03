import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

abstract class FavoriteListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteListInit extends FavoriteListEvent {}

class GetCarPic1Event extends FavoriteListEvent {
  GetCarPic1Event(this.context);

  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class AddCarLocalEvent extends FavoriteListEvent {
  AddCarLocalEvent(this.item, this.tableName, this.questionNo);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  @override
  List<Object> get props => [item, tableName, questionNo];
}

class RemoveCarEvent extends FavoriteListEvent {
  RemoveCarEvent(this.tableName, this.index);

  final String tableName;
  final int index;
  @override
  List<Object> get props => [tableName, index];
}

class SaveCarToDBEvent extends FavoriteListEvent {
  SaveCarToDBEvent(this.item, this.indexSave);
  final ItemSearchModel item;
  final int indexSave;

  @override
  List<Object> get props => [item, indexSave];
}

class GetCarFavoriteEvent extends FavoriteListEvent {
  GetCarFavoriteEvent(
    this.tableName,
    this.mapGet,
  );
  final String tableName;
  final Map<String, String> mapGet;

  @override
  List<Object> get props => [tableName, mapGet];
}
