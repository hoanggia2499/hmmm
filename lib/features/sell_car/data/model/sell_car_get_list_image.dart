import 'package:equatable/equatable.dart';

class SellCarGetCarImagesRequestModel extends Equatable {
  final String? memberNum;
  final String? userNum;
  final String? userCarNum;
  final String? upKind;

  SellCarGetCarImagesRequestModel(
      {this.memberNum, this.userNum, this.userCarNum, this.upKind});

  @override
  List<Object?> get props => [memberNum, userNum, userCarNum, upKind];
}
