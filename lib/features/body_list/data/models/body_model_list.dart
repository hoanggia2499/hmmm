import 'package:mirukuru/core/network/json_convert_base.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';

class BodyModelList extends JsonConvert<BodyModelList> {
  List<BodyModel> bodyModelList;

  BodyModelList({this.bodyModelList = const []});
}
