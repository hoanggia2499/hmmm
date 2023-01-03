import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PhotoManager {
  Uint8List? bmp;
  String? memberNum;
  String? userNum;
  String? userCarNum;
  String? upKind;
  bool? isFirstRegist;
  String? photoName;
  XFile? xfile;

  PhotoManager(
      {this.bmp,
      this.userNum,
      this.memberNum,
      this.userCarNum,
      this.upKind,
      this.isFirstRegist,
      this.photoName,
      this.xfile});
}
