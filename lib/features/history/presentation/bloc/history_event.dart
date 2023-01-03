import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

import '../../../search_list/data/models/favorite_access_model.dart';

abstract class HistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetFavoriteAccessEvent extends HistoryEvent {
  GetFavoriteAccessEvent(this.context, this.favoriteAccessModel);

  final BuildContext context;
  final FavoriteAccessModel favoriteAccessModel;
  @override
  List<Object> get props => [context];
}

class LoadItemSearchHistoryList extends HistoryEvent {}

class LoadSearchInputHistoryList extends HistoryEvent {}

class GetHistoryDataEvent extends HistoryEvent {}

class AddCarLocalEvent extends HistoryEvent {
  AddCarLocalEvent(this.item, this.tableName, this.questionNo);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  @override
  List<Object> get props => [item, tableName, questionNo];
}

class DeleteFavoriteByPositionEvent extends HistoryEvent {
  DeleteFavoriteByPositionEvent(this.tableName, this.questionNo);
  final String tableName;
  final String questionNo;
  @override
  List<Object> get props => [tableName, questionNo];
}

class RemoveCarEvent extends HistoryEvent {
  RemoveCarEvent(this.item, this.tableName, this.questionNo, this.index);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;
  final int index;
  @override
  List<Object> get props => [item, tableName, questionNo, index];
}

class SaveCarToDBEvent extends HistoryEvent {
  SaveCarToDBEvent(this.item, this.index);
  final ItemSearchModel item;
  final int index;

  @override
  List<Object> get props => [item, index];
}

class InitFavoriteListEvent extends HistoryEvent {}

class SaveFavoriteToDBEvent extends HistoryEvent {
  SaveFavoriteToDBEvent(
    this.item,
  );
  final ItemSearchModel item;
  @override
  List<Object> get props => [
        item,
      ];
}

class DeleteFavoriteFromDBEvent extends HistoryEvent {
  DeleteFavoriteFromDBEvent(this.item, this.showFavorite);
  final ItemSearchModel item;
  final Function showFavorite;

  @override
  List<Object> get props => [item, showFavorite];
}
