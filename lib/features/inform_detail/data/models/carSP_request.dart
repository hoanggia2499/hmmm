import 'package:equatable/equatable.dart';

class CarSPRequestModel extends Equatable {
  final String? memberNum;
  final String? corner;
  final String? aACount;
  final String? exhNum;

  CarSPRequestModel({
    this.memberNum,
    this.corner,
    this.aACount,
    this.exhNum,
  });

  @override
  List<Object?> get props => [memberNum, corner, aACount, exhNum];
}
