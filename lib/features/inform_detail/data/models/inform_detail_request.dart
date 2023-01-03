import 'package:equatable/equatable.dart';

class InformDetailRequestModel extends Equatable {
  final String? memberNum;
  final int? userNum;
  final int? sendNum;

  InformDetailRequestModel({
    this.memberNum,
    this.userNum,
    this.sendNum,
  });

  @override
  List<Object?> get props => [memberNum, userNum, sendNum];
}
