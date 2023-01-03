import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../search_list/data/models/item_search_model.dart';

@immutable
abstract class FavoriteListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends FavoriteListState {}

class Loading extends FavoriteListState {}

class Loaded extends FavoriteListState {
  final List<ItemSearchModel> favoriteObjectList;

  Loaded({required this.favoriteObjectList});

  @override
  List<Object> get props => [favoriteObjectList];
}

class Error extends FavoriteListState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends FavoriteListState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}
