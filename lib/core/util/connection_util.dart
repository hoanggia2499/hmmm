import 'dart:io';

import 'package:mirukuru/core/util/logger_util.dart';

class InternetConnection {
  static InternetConnection instance = InternetConnection._internal();

  factory InternetConnection() {
    return instance;
  }

  InternetConnection._internal();

  Future<bool> isHasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      Logging.log.error('not connected ${_.toString()}');
      return false;
    }
    return false;
  }
}
