/// tel : "00-9999-1408"
/// repairFlag : 0
/// dtPointTotal : null
/// carName : "エスクァイア"
/// makerName : "トヨタ"
/// carGrade : "Ｇｉ"
/// corner : "13"
/// aaCount : 1510
/// exhNum : 690
/// fullExhNum : "15100690"
/// carModel : 2019
/// carVolume : 2000
/// carMileage : 21
/// inspection : "202210"
/// sysColorName : "パール"
/// fuelName : "ガソリン"
/// carLocation : "大阪府"
/// shiftName : "AT"
/// price : "0"
/// stars : "0"

class CarSPResponseModel {
  CarSPResponseModel({
    String? tel,
    int? repairFlag,
    dynamic dtPointTotal,
    String? carName,
    String? makerName,
    String? carGrade,
    String? corner,
    int? aaCount,
    int? exhNum,
    String? fullExhNum,
    int? carModel,
    int? carVolume,
    int? carMileage,
    String? inspection,
    String? sysColorName,
    String? fuelName,
    String? carLocation,
    String? shiftName,
    String? price,
    String? stars,
  }) {
    _tel = tel;
    _repairFlag = repairFlag;
    _dtPointTotal = dtPointTotal;
    _carName = carName;
    _makerName = makerName;
    _carGrade = carGrade;
    _corner = corner;
    _aaCount = aaCount;
    _exhNum = exhNum;
    _fullExhNum = fullExhNum;
    _carModel = carModel;
    _carVolume = carVolume;
    _carMileage = carMileage;
    _inspection = inspection;
    _sysColorName = sysColorName;
    _fuelName = fuelName;
    _carLocation = carLocation;
    _shiftName = shiftName;
    _price = price;
    _stars = stars;
  }

  CarSPResponseModel.fromJson(dynamic json) {
    _tel = json['tel'];
    _repairFlag = json['repairFlag'];
    _dtPointTotal = json['dtPointTotal'];
    _carName = json['carName'];
    _makerName = json['makerName'];
    _carGrade = json['carGrade'];
    _corner = json['corner'];
    _aaCount = json['aaCount'];
    _exhNum = json['exhNum'];
    _fullExhNum = json['fullExhNum'];
    _carModel = json['carModel'];
    _carVolume = json['carVolume'];
    _carMileage = json['carMileage'];
    _inspection = json['inspection'];
    _sysColorName = json['sysColorName'];
    _fuelName = json['fuelName'];
    _carLocation = json['carLocation'];
    _shiftName = json['shiftName'];
    _price = json['price'];
    _stars = json['stars'];
  }
  String? _tel;
  int? _repairFlag;
  dynamic _dtPointTotal;
  String? _carName;
  String? _makerName;
  String? _carGrade;
  String? _corner;
  int? _aaCount;
  int? _exhNum;
  String? _fullExhNum;
  int? _carModel;
  int? _carVolume;
  int? _carMileage;
  String? _inspection;
  String? _sysColorName;
  String? _fuelName;
  String? _carLocation;
  String? _shiftName;
  String? _price;
  String? _stars;

  String? get tel => _tel;
  int? get repairFlag => _repairFlag;
  dynamic get dtPointTotal => _dtPointTotal;
  String? get carName => _carName;
  String? get makerName => _makerName;
  String? get carGrade => _carGrade;
  String? get corner => _corner;
  int? get aaCount => _aaCount;
  int? get exhNum => _exhNum;
  String? get fullExhNum => _fullExhNum;
  int? get carModel => _carModel;
  int? get carVolume => _carVolume;
  int? get carMileage => _carMileage;
  String? get inspection => _inspection;
  String? get sysColorName => _sysColorName;
  String? get fuelName => _fuelName;
  String? get carLocation => _carLocation;
  String? get shiftName => _shiftName;
  String? get price => _price;
  String? get stars => _stars;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tel'] = _tel;
    map['repairFlag'] = _repairFlag;
    map['dtPointTotal'] = _dtPointTotal;
    map['carName'] = _carName;
    map['makerName'] = _makerName;
    map['carGrade'] = _carGrade;
    map['corner'] = _corner;
    map['aaCount'] = _aaCount;
    map['exhNum'] = _exhNum;
    map['fullExhNum'] = _fullExhNum;
    map['carModel'] = _carModel;
    map['carVolume'] = _carVolume;
    map['carMileage'] = _carMileage;
    map['inspection'] = _inspection;
    map['sysColorName'] = _sysColorName;
    map['fuelName'] = _fuelName;
    map['carLocation'] = _carLocation;
    map['shiftName'] = _shiftName;
    map['price'] = _price;
    map['stars'] = _stars;
    return map;
  }
}
