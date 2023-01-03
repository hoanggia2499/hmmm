import 'core/config/app_properties.dart';
import 'main_common.dart';

void main() async {
  await mainCommon(AppProperties(
    // Set at production
    apSrvURL: 'https://www.mlkl.jp',
    imgSrvURL: 'https://img.mlkl.jp',
  ));
}
