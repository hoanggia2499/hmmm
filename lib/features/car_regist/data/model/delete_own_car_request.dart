import 'package:equatable/equatable.dart';

class DeleteOwnCarRequestModel extends Equatable {
  final String? memberNum;
  final int? userNum;
  final int? userCarNum;

  DeleteOwnCarRequestModel({
    this.memberNum,
    this.userNum,
    this.userCarNum,
  });

  @override
  List<Object?> get props => [memberNum, userNum, userCarNum];
}
