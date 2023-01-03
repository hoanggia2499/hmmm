import 'dart:convert';

class UserCarNameModel {
  String? makerCode;
  String? makerName;
  String? carGroup;
  String? asnetCarCode;
  String? userCarNum;

  UserCarNameModel(
      {this.makerCode,
      this.makerName,
      this.carGroup,
      this.asnetCarCode,
      this.userCarNum});

  UserCarNameModel copyWith({
    String? makerCode,
    String? makerName,
    String? carGroup,
    String? asnetCarCode,
    String? userCarNum,
  }) {
    return UserCarNameModel(
      makerCode: makerCode ?? this.makerCode,
      makerName: makerName ?? this.makerName,
      carGroup: carGroup ?? this.carGroup,
      asnetCarCode: asnetCarCode ?? this.asnetCarCode,
      userCarNum: userCarNum ?? this.userCarNum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'makerCode': makerCode,
      'makerName': makerName,
      'carGroup': carGroup,
      'asnetCarCode': asnetCarCode,
      'userCarNum': userCarNum,
    };
  }

  factory UserCarNameModel.fromMap(Map<String, dynamic> map) {
    return UserCarNameModel(
      makerCode: map['makerCode'],
      makerName: map['makerName'],
      carGroup: map['carGroup'],
      asnetCarCode: map['asnetCarCode'],
      userCarNum: map['userCarNum'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCarNameModel.fromJson(String source) =>
      UserCarNameModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserCarNameModel(makerCode: $makerCode, makerName: $makerName, carGroup: $carGroup, asnetCarCode: $asnetCarCode, userCarNum: $userCarNum)';
  }

  String displayUserCarName() {
    return "$makerName $carGroup";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserCarNameModel &&
        other.makerCode == makerCode &&
        other.makerName == makerName &&
        other.carGroup == carGroup &&
        other.asnetCarCode == asnetCarCode &&
        other.userCarNum == userCarNum;
  }

  @override
  int get hashCode {
    return makerCode.hashCode ^
        makerName.hashCode ^
        carGroup.hashCode ^
        asnetCarCode.hashCode ^
        userCarNum.hashCode;
  }
}
