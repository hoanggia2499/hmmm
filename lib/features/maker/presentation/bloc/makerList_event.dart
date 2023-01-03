import 'package:equatable/equatable.dart';

abstract class MakerListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MakerListInit extends MakerListEvent {}
