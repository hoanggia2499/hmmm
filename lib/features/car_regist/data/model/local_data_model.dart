import '../../../../core/db/name_bean_hive.dart';

class RIKUJIModel {
  final String nameCode;
  final int nameKbn;

  RIKUJIModel(this.nameCode, this.nameKbn);
}

class LocalModel {
  final List<RIKUJIModel> listRIKUJI;
  final List<NameBeanHive> listNameBeanHive;

  LocalModel(this.listRIKUJI, this.listNameBeanHive);
}

class SelectionFieldModel {
  DateTime? inspectionDate;
  DateTime? nHokenEndDate;
  int? mCarModel;
  String? mColorName;
  String? mSellTime;
  String? mInsuranceCompany;

  SelectionFieldModel({
    this.inspectionDate,
    this.nHokenEndDate,
    this.mCarModel,
    this.mColorName,
    this.mSellTime,
    this.mInsuranceCompany,
  });

  SelectionFieldModel copyWith({
    DateTime? inspectionDate,
    DateTime? nHokenEndDate,
    int? mCarModel,
    String? mColorName,
    String? mSellTime,
    String? mInsuranceCompany,
  }) {
    return SelectionFieldModel(
      inspectionDate: inspectionDate,
      nHokenEndDate: nHokenEndDate,
      mCarModel: mCarModel,
      mColorName: mColorName,
      mSellTime: mSellTime,
      mInsuranceCompany: mInsuranceCompany,
    );
  }
}

class InputTextModel {
  final String? mCategoryNumber;
  final String? mGradeHiragana;
  final String? mSpecifyNumber;
  final String? mDistance;
  final String? mVehicleNumber;
  final String? mGradeValue;

  InputTextModel({
    this.mCategoryNumber,
    this.mGradeHiragana,
    this.mSpecifyNumber,
    this.mDistance,
    this.mVehicleNumber,
    this.mGradeValue,
  });

  InputTextModel copyWith({
    String? mCategoryNumber,
    String? mGradeHiragana,
    String? mSpecifyNumber,
    String? mDistance,
    String? mVehicleNumber,
    String? mGradeValue,
  }) {
    return InputTextModel(
      mCategoryNumber: mCategoryNumber ?? this.mCategoryNumber,
      mGradeHiragana: mGradeHiragana ?? this.mGradeHiragana,
      mSpecifyNumber: mSpecifyNumber ?? this.mSpecifyNumber,
      mDistance: mDistance ?? this.mDistance,
      mVehicleNumber: mVehicleNumber ?? this.mVehicleNumber,
      mGradeValue: mGradeValue ?? this.mGradeValue,
    );
  }
}
