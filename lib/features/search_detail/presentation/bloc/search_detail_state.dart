import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';

@immutable
abstract class SearchDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends SearchDetailState {}

class Loading extends SearchDetailState {}

class Loaded extends SearchDetailState {
  final List<SearchCarModel> searchCarModelList;

  Loaded({required this.searchCarModelList});

  @override
  List<Object> get props => [searchCarModelList];
}

class LoadedImage extends SearchDetailState {
  final String imageCount;

  LoadedImage({required this.imageCount});

  @override
  List<Object> get props => [imageCount];
}

class LoadedImageTotal extends SearchDetailState {
  final String imageCount;

  LoadedImageTotal({required this.imageCount});

  @override
  List<Object> get props => [imageCount];
}

class Error extends SearchDetailState {
  final String messageCode;
  final String messageContent;

  Error({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class TimeOut extends SearchDetailState {
  final String messageCode;
  final String messageContent;

  TimeOut({required this.messageCode, required this.messageContent});

  @override
  List<Object> get props => [messageCode, messageContent];
}

class CountImageCarState extends SearchDetailState {
  final int countImage;

  CountImageCarState({required this.countImage});

  @override
  List<Object> get props => [countImage];
}
