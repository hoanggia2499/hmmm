import 'dart:convert';

class AsnetCarDetailRequestModel {
  final String carNo;
  final String memberNum;
  AsnetCarDetailRequestModel({
    required this.carNo,
    required this.memberNum,
  });

  AsnetCarDetailRequestModel copyWith({
    String? carNo,
    String? memberNum,
  }) {
    return AsnetCarDetailRequestModel(
      carNo: carNo ?? this.carNo,
      memberNum: memberNum ?? this.memberNum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carNo': carNo,
      'memberNum': memberNum,
    };
  }

  factory AsnetCarDetailRequestModel.fromMap(Map<String, dynamic> map) {
    return AsnetCarDetailRequestModel(
      carNo: map['carNo'] ?? '',
      memberNum: map['memberNum'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AsnetCarDetailRequestModel.fromJson(String source) =>
      AsnetCarDetailRequestModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuotationDetailRequest(carNo: $carNo, memberNum: $memberNum)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AsnetCarDetailRequestModel &&
        other.carNo == carNo &&
        other.memberNum == memberNum;
  }

  @override
  int get hashCode => carNo.hashCode ^ memberNum.hashCode;
}
