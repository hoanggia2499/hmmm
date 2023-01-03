import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/db/favorite_hive.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

@immutable
abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends HistoryState {}

class Loading extends HistoryState {}

class ItemHistoryListLoaded extends HistoryState {
  final List<ItemSearchModel> itemHistoryList;

  ItemHistoryListLoaded(this.itemHistoryList);

  @override
  List<Object> get props => [itemHistoryList];
}

class TimeOut extends HistoryState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class SearchInputHistoryListLoaded extends HistoryState {
  final List<SearchListModel> searchListModelList;

  SearchInputHistoryListLoaded(this.searchListModelList);

  @override
  List<Object> get props => [searchListModelList];
}

class Loaded extends HistoryState {
  final List<SearchListModel>? searchListModelList;
  final List<ItemSearchModel>? itemHistoryList;

  Loaded({this.searchListModelList, this.itemHistoryList});

  @override
  List<Object?> get props => [searchListModelList, itemHistoryList];
}

class Error extends HistoryState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class LoadedInitFavorite extends HistoryState {
  final List<FavoriteHive> listFavoriteHive;

  LoadedInitFavorite({required this.listFavoriteHive});

  @override
  List<Object> get props => [listFavoriteHive];
}
