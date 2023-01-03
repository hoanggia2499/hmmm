import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/db/favorite_hive.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

@immutable
abstract class SearchListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends SearchListState {}

class Loading extends SearchListState {}

class Loaded extends SearchListState {
  final List<ItemSearchModel> listItemSearchModel;

  Loaded({required this.listItemSearchModel});

  @override
  List<Object> get props => [listItemSearchModel];
}

class RequestEstimate extends SearchListState {
  final int numberOfQuotationToday;

  RequestEstimate({required this.numberOfQuotationToday});

  @override
  List<Object> get props => [numberOfQuotationToday];
}

class Error extends SearchListState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends SearchListState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class LoadedInitFavorite extends SearchListState {
  final List<FavoriteHive> listFavoriteHive;

  LoadedInitFavorite({required this.listFavoriteHive});

  @override
  List<Object> get props => [listFavoriteHive];
}
