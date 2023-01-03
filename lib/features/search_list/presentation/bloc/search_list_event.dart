import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/features/search_input/data/models/search_input_model.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

abstract class SearchListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchListInit extends SearchListEvent {}

class GetSearchListEvent extends SearchListEvent {
  GetSearchListEvent(this.context, this.searchListModel, this.pic1Map);

  final BuildContext context;
  final SearchListModel searchListModel;
  final Map<String, String> pic1Map;
  @override
  List<Object> get props => [context, searchListModel, pic1Map];
}

class GetCarPic1Event extends SearchListEvent {
  GetCarPic1Event(this.context, this.searchListModel, this.count, this.type);

  final BuildContext context;
  final SearchInputModel searchListModel;
  final int count;
  final int
      type; //type 0: search history default type 1: search with condition history local data
  @override
  List<Object> get props => [context, searchListModel, count, type];
}

class GetFavoriteAccessEvent extends SearchListEvent {
  GetFavoriteAccessEvent(this.context, this.favoriteAccessModel);

  final BuildContext context;
  final FavoriteAccessModel favoriteAccessModel;
  @override
  List<Object> get props => [context];
}

class RequestEstimateEvent extends SearchListEvent {
  RequestEstimateEvent(this.context, this.memberNum, this.userNum);
  final String memberNum;
  final int userNum;
  final BuildContext context;
  @override
  List<Object> get props => [context, memberNum, userNum];
}

class IncreaseRequestCountEvent extends SearchListEvent {
  IncreaseRequestCountEvent(this.context, this.currentNumberOfChecked);
  final int currentNumberOfChecked;
  final BuildContext context;
  @override
  List<Object> get props => [context, currentNumberOfChecked];
}

class AddCarLocalEvent extends SearchListEvent {
  AddCarLocalEvent(this.item, this.tableName, this.questionNo);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;

  @override
  List<Object> get props => [item, tableName, questionNo];
}

class DeleteFavoriteByPositionEvent extends SearchListEvent {
  DeleteFavoriteByPositionEvent(this.tableName, this.questionNo);
  final String tableName;
  final String questionNo;
  @override
  List<Object> get props => [tableName, questionNo];
}

class RemoveCarEvent extends SearchListEvent {
  RemoveCarEvent(this.item, this.tableName, this.questionNo, this.index);
  final ItemSearchModel item;
  final String tableName;
  final String questionNo;
  final int index;
  @override
  List<Object> get props => [item, tableName, questionNo, index];
}

class SaveCarToDBEvent extends SearchListEvent {
  SaveCarToDBEvent(
    this.item,
  );
  final ItemSearchModel item;

  @override
  List<Object> get props => [
        item,
      ];
}

class InitFavoriteListEvent extends SearchListEvent {}

class SaveFavoriteToDBEvent extends SearchListEvent {
  SaveFavoriteToDBEvent(
    this.item,
  );
  final ItemSearchModel item;

  @override
  List<Object> get props => [
        item,
      ];
}

class DeleteFavoriteFromDBEvent extends SearchListEvent {
  DeleteFavoriteFromDBEvent(
    this.item,
  );
  final ItemSearchModel item;

  @override
  List<Object> get props => [
        item,
      ];
}
