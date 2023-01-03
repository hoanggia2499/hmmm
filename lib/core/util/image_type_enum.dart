import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

enum ImageTypeEnum {
  NETWORK_IMAGE,
  ASSET_SVG,
  ASSET_IMAGE,
  FILE,
  XFILE,
  UINT8LIST
}

extension ImageTypeExtension on ImageTypeEnum {
  static ImageTypeEnum getTypeFromExtension(dynamic data) {
    if (data is Uint8List) {
      return ImageTypeEnum.UINT8LIST;
    } else if (data is XFile) {
      return ImageTypeEnum.XFILE;
    } else if (data is File) {
      return ImageTypeEnum.FILE;
    } else if (data is String) {
      var dataString = data;
      if (Uri.parse(dataString).host.isNotEmpty) {
        return ImageTypeEnum.NETWORK_IMAGE;
      } else if (dataString.contains(".svg")) {
        return ImageTypeEnum.ASSET_SVG;
      } else {
        return ImageTypeEnum.ASSET_IMAGE;
      }
    }
    return ImageTypeEnum.ASSET_IMAGE;
  }
}
