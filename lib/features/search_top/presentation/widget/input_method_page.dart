import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/util/app_route.dart';
import 'package:mirukuru/core/widgets/common/button_image_menu.dart';

class InputMethodPage extends StatefulWidget {
  InputMethodPage({Key? key}) : super(key: key);

  @override
  _InputMethodPage createState() => _InputMethodPage();
}

class _InputMethodPage extends State<InputMethodPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ResourceColors.color_C1C1C1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                ButtonImageMenu(
                  imageOn: 'top_find_car_on.png',
                  imageOff: 'top_find_car_off.png',
                  onPress: () async {
                    await Navigator.of(context)
                        .pushNamed(AppRoutes.searchTopPage);
                  },
                ),
                ButtonImageMenu(
                  imageOn: 'top_sell_car_on.png',
                  imageOff: 'top_sell_car_off.png',
                  onPress: () {
                    // Navigator.pushNamed(context, Routes.barCodeTypePage);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                ButtonImageMenu(
                  imageOn: 'top_inform_on.png',
                  imageOff: 'top_inform_off.png',
                  onPress: () {
                    // Navigator.pushNamed(context, Routes.barCodeTypePage);
                  },
                ),
                ButtonImageMenu(
                  imageOn: 'top_inquiry_on.png',
                  imageOff: 'top_inquiry_off.png',
                  onPress: () {
                    // Navigator.pushNamed(context, Routes.barCodeTypePage);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
