import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class SellCarModel extends Equatable {
  String? memberNum;
  int? userNum;
  String? exhNum;
  int? userCarNum;
  int? makerCode;
  String? makerName;
  String? carName;
  int? id;
  String? question;
  String? questionKbn;
  String? upKind;
  List<XFile?>? files;

  SellCarModel({
    this.memberNum,
    this.userNum,
    this.exhNum,
    this.userCarNum,
    this.makerCode,
    this.makerName,
    this.carName,
    this.id,
    this.question,
    this.questionKbn,
    this.upKind,
    this.files,
  });

  @override
  List<Object?> get props => [
        memberNum,
        userNum,
        exhNum,
        userCarNum,
        makerCode,
        makerName,
        carName,
        id,
        question,
        questionKbn,
        upKind,
        files,
      ];
}
