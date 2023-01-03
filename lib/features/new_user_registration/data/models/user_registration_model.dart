class UserRegistrationModel {
  UserRegistrationModel({
    this.storeName = '',
    this.personalAuthFlag = '',
    this.isExists = false,
  });

  final String storeName;
  final String personalAuthFlag;
  final bool isExists;

  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) {
    return UserRegistrationModel(
      storeName: json['storeName'] ?? '',
      personalAuthFlag: json['personalAuthFlag'] ?? '',
      isExists: json['isExists'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'personalAuthFlag': personalAuthFlag,
      'isExists': isExists,
    };
  }
}
