import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

abstract class FavoriteDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchDetailInit extends FavoriteDetailEvent {}

class SearchCarEvent extends FavoriteDetailEvent {
  SearchCarEvent(this.context, this.searchCarInputModel);
  final SearchCarInputModel searchCarInputModel;
  final BuildContext context;
  @override
  List<Object> get props => [context, searchCarInputModel];
}

class CountImageEvent extends FavoriteDetailEvent {
  CountImageEvent(this.context, this.currentNumberOfChecked);
  final int currentNumberOfChecked;
  final BuildContext context;
  @override
  List<Object> get props => [context, currentNumberOfChecked];
}

class CountImageTotalEvent extends FavoriteDetailEvent {
  CountImageTotalEvent(this.context, this.currentNumberOfChecked);
  final int currentNumberOfChecked;
  final BuildContext context;
  @override
  List<Object> get props => [context, currentNumberOfChecked];
}

class AddCarLocalEvent extends FavoriteDetailEvent {
  AddCarLocalEvent(this.item, this.tableName, this.questionNo);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  @override
  List<Object> get props => [item, tableName, questionNo];
}

class DeleteFavoriteByPositionEvent extends FavoriteDetailEvent {
  DeleteFavoriteByPositionEvent(this.tableName, this.questionNo);
  final String tableName;
  final String questionNo;
  @override
  List<Object> get props => [tableName, questionNo];
}

class RemoveCarEvent extends FavoriteDetailEvent {
  RemoveCarEvent(this.item, this.tableName, this.questionNo, this.index);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;
  final int index;
  @override
  List<Object> get props => [item, tableName, questionNo, index];
}

class InitFavoriteListEvent extends FavoriteDetailEvent {}

class SaveFavoriteToDBEvent extends FavoriteDetailEvent {
  SaveFavoriteToDBEvent(
    this.item,
  );
  final ItemSearchModel item;

  @override
  List<Object> get props => [
        item,
      ];
}

class DeleteFavoriteFromDBEvent extends FavoriteDetailEvent {
  DeleteFavoriteFromDBEvent(
    this.item,
  );
  final ItemSearchModel item;

  @override
  List<Object> get props => [
        item,
      ];
}
