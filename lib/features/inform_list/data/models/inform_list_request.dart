import 'package:equatable/equatable.dart';

class InformListRequestModel extends Equatable {
  final String? memberNum;
  final int? userNum;

  InformListRequestModel({
    this.memberNum,
    this.userNum,
  });

  @override
  List<Object?> get props => [memberNum, userNum];
}
