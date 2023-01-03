import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_input_model.dart';
import 'package:mirukuru/features/search_list/data/models/favorite_access_model.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

abstract class SearchDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchDetailInit extends SearchDetailEvent {}

class SearchCarEvent extends SearchDetailEvent {
  SearchCarEvent(this.context, this.searchCarInputModel);
  final SearchCarInputModel searchCarInputModel;
  final BuildContext context;
  @override
  List<Object> get props => [context, searchCarInputModel];
}

class CountImageEvent extends SearchDetailEvent {
  CountImageEvent(this.context, this.currentNumberOfChecked);
  final int currentNumberOfChecked;
  final BuildContext context;
  @override
  List<Object> get props => [context, currentNumberOfChecked];
}

class CountImageTotalEvent extends SearchDetailEvent {
  CountImageTotalEvent(this.context, this.currentNumberOfChecked);
  final int currentNumberOfChecked;
  final BuildContext context;
  @override
  List<Object> get props => [context, currentNumberOfChecked];
}

class SaveFavoriteToDBEvent extends SearchDetailEvent {
  SaveFavoriteToDBEvent(this.itemSearchModel);
  final ItemSearchModel itemSearchModel;

  @override
  List<Object> get props => [itemSearchModel];
}

class DeleteFavoriteFromDBEvent extends SearchDetailEvent {
  DeleteFavoriteFromDBEvent(this.itemSearchModel);
  final ItemSearchModel itemSearchModel;

  @override
  List<Object> get props => [itemSearchModel];
}

class GetFavoriteAccessEvent extends SearchDetailEvent {
  GetFavoriteAccessEvent(this.context, this.favoriteAccessModel);

  final BuildContext context;
  final FavoriteAccessModel favoriteAccessModel;
  @override
  List<Object> get props => [context];
}
