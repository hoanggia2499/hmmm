import 'core/config/app_properties.dart';
import 'main_common.dart';

void main() async {
  await mainCommon(AppProperties(
    apSrvURL: 'http://192.168.200.114:8888',
    imgSrvURL: 'http://192.168.200.114',
  ));
}
