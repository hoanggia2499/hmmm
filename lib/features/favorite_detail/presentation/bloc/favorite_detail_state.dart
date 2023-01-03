import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';

@immutable
abstract class FavoriteDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends FavoriteDetailState {}

class Loading extends FavoriteDetailState {}

class Loaded extends FavoriteDetailState {
  final List<SearchCarModel> searchCarModelList;

  Loaded({required this.searchCarModelList});

  @override
  List<Object> get props => [searchCarModelList];
}

class LoadedImage extends FavoriteDetailState {
  final String imageCount;

  LoadedImage({required this.imageCount});

  @override
  List<Object> get props => [imageCount];
}

class LoadedImageTotal extends FavoriteDetailState {
  final String imageCount;

  LoadedImageTotal({required this.imageCount});

  @override
  List<Object> get props => [imageCount];
}

class Error extends FavoriteDetailState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends FavoriteDetailState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class CountImageCarState extends FavoriteDetailState {
  final int countImage;

  CountImageCarState({required this.countImage});

  @override
  List<Object> get props => [countImage];
}
