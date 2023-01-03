import 'package:equatable/equatable.dart';

class GetCarImagesRequestModel extends Equatable {
  final String? memberNum;
  final String? userNum;
  final String? userCarNum;
  final String? upKind;

  GetCarImagesRequestModel(
      {this.memberNum, this.userNum, this.userCarNum, this.upKind});

  @override
  List<Object?> get props => [memberNum, userNum, userCarNum, upKind];
}
