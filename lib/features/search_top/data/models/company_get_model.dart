class CompanyGetModel {
  CompanyGetModel({
    this.memberNum = '',
    this.storeName = '',
    this.tel = '',
    this.email = '',
    this.address1 = '',
    this.address2 = '',
    this.holiday = '',
    this.saleTime = '',
    this.photo = '',
    this.zipCode = '',
    this.logoMark = '',
  });

  final String memberNum;
  final String storeName;
  final String tel;
  final String email;
  final String address1;
  final String address2;
  final String holiday;
  final String saleTime;
  final String photo;
  final String zipCode;
  final String logoMark;

  factory CompanyGetModel.fromJson(Map<String, dynamic> json) {
    return CompanyGetModel(
      memberNum: json['memberNum'] ?? '',
      storeName: json['storeName'] ?? '',
      tel: json['tel'] ?? '',
      email: json['email'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      holiday: json['holiday'] ?? '',
      saleTime: json['saleTime'] ?? '',
      photo: json['photo'] ?? '',
      zipCode: json['zipCode'] ?? '',
      logoMark: json['logoMark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberNum': memberNum,
      'storeName': storeName,
      'tel': storeName,
      'email': email,
      'address1': address1,
      'address2': address2,
      'holiday': holiday,
      'saleTime': saleTime,
      'photo': photo,
      'zipCode': zipCode,
      'logoMark': logoMark,
    };
  }
}
