import 'package:equatable/equatable.dart';

class ItemMakerModel extends Equatable {
  ItemMakerModel({
    this.makerCode = '',
    this.makerName = '',
    this.numOfCarASOne = 0,
  });

  final String makerCode;
  final String makerName;
  final int numOfCarASOne;

  factory ItemMakerModel.fromJson(Map<String, dynamic> json) {
    return ItemMakerModel(
      makerCode: json['makerCode'] ?? '',
      makerName: json['makerName'] ?? '',
      numOfCarASOne: json['numOfCarASOne'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'makerCode': makerCode,
      'makerName': makerName,
      'numOfCarASOne': numOfCarASOne,
    };
  }

  @override
  List<Object?> get props => [makerCode, makerName, numOfCarASOne];
}
