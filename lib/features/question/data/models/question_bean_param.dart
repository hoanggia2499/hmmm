import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:mirukuru/core/network/paginated_data_request_model.dart';

class QuestionBeanParam extends PaginatedDataRequestModel with EquatableMixin {
  String memberNum;
  int userNum;
  int sortId;

  QuestionBeanParam({
    int pageIndex = 1,
    int pageSize = 10,
    required this.memberNum,
    required this.userNum,
    required this.sortId,
  }) : super(pageIndex: pageIndex, pageSize: pageSize);

  Map<String, dynamic> toMap() {
    return {
      'memberNum': memberNum,
      'userNum': userNum,
      'sortId': sortId,
      'page': pageIndex,
      'per_page': pageSize
    };
  }

  factory QuestionBeanParam.fromMap(Map<String, dynamic> map) {
    return QuestionBeanParam(
      memberNum: map['memberNum'] ?? '',
      userNum: map['userNum']?.toInt() ?? 0,
      sortId: map['sortId']?.toInt() ?? 0,
      pageIndex: map['page']?.toInt() ?? 0,
      pageSize: map['per_page']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionBeanParam.fromJson(String source) =>
      QuestionBeanParam.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuestionBeanParam(memberNum: $memberNum, userNum: $userNum, sortId: $sortId, pageIndex: $pageIndex, pageSize: $pageSize)';

  @override
  List<Object> get props => [memberNum, userNum, sortId, pageIndex, pageSize];

  QuestionBeanParam copyWith(
      {String? memberNum,
      int? userNum,
      int? sortId,
      int? pageIndex,
      int? pageSize}) {
    return QuestionBeanParam(
      memberNum: memberNum ?? this.memberNum,
      userNum: userNum ?? this.userNum,
      sortId: sortId ?? this.sortId,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
