import 'package:equatable/equatable.dart';

class PostOwnCarResponse extends Equatable {
  int? userCarNum;

  PostOwnCarResponse({this.userCarNum});

  factory PostOwnCarResponse.fromJson(Map<String, dynamic> map) {
    return PostOwnCarResponse(userCarNum: map['userCarNum'] ?? "");
  }

  @override
  List<Object?> get props => [];
}
