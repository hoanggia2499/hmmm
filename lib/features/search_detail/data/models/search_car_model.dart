class SearchCarModel {
  String carName;
  String makerName;
  String makerCode;
  String carGrade;
  String corner;
  int aaCount;
  int exhNum;
  String fullExhNum;
  int carVolume;
  int carMileage;
  int carModel;
  String inspection;
  String sysColorName;
  String fuelName;
  String carLocation;
  String shiftName;
  String carForm;
  String platformNum;
  int carDoors;
  String sellingPoint;
  String handleName;
  int equipCode;
  String equipment;
  String acName;
  String historyName;
  String tel;
  String pic;

  SearchCarModel(
      {this.makerCode = '',
      this.exhNum = 0,
      this.corner = '',
      this.fullExhNum = '',
      this.carGrade = '',
      this.sysColorName = '',
      this.carLocation = '',
      this.fuelName = '',
      this.shiftName = '',
      this.carVolume = 0,
      this.carName = '',
      this.makerName = '',
      this.tel = '',
      this.carModel = 0,
      this.carMileage = 0,
      this.aaCount = 0,
      this.inspection = '',
      this.acName = '',
      this.carDoors = 0,
      this.carForm = '',
      this.equipCode = 0,
      this.equipment = '',
      this.handleName = '',
      this.historyName = '',
      this.pic = '',
      this.platformNum = '',
      this.sellingPoint = ''});

  factory SearchCarModel.fromJson(Map<String, dynamic> json) {
    return SearchCarModel(
      carName: json['carName'] ?? '',
      makerName: json['makerName'] ?? '',
      makerCode: json['makerCode'] ?? '',
      carGrade: json['carGrade'] ?? '',
      corner: json['corner'] ?? '',
      fullExhNum: json['fullExhNum'] ?? '',
      inspection: json['inspection'] ?? '',
      sysColorName: json['sysColorName'] ?? '',
      fuelName: json['fuelName'] ?? '',
      carLocation: json['carLocation'] ?? '',
      shiftName: json['shiftName'] ?? '',
      aaCount: json['aaCount'] ?? '',
      exhNum: json['exhNum'] ?? '',
      carVolume: json['carVolume'] ?? '',
      carMileage: json['carMileage'] ?? '',
      carModel: json['carModel'] ?? '',
      tel: json['tel'] ?? '',
      acName: json['acName'] ?? '',
      carDoors: json['carDoors'] ?? '',
      carForm: json['carForm'] ?? '',
      equipCode: json['equipCode'] ?? '',
      equipment: json['equipment'] ?? '',
      handleName: json['handleName'] ?? '',
      historyName: json['historyName'] ?? '',
      pic: json['pic'] ?? '',
      platformNum: json['platformNum'] ?? '',
      sellingPoint: json['sellingPoint'] ?? '',
    );
  }
}
