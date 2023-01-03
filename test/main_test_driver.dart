import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as app;
import 'package:mirukuru/core/config/app_properties.dart';
import 'package:mirukuru/main_common.dart';

void main() async {
  enableFlutterDriverExtension();
  await mainCommon(AppProperties(
    apSrvURL: 'http://192.168.200.114:8888',
    imgSrvURL: 'http://192.168.200.114',
  ));
}
