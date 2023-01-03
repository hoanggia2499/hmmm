import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/common/button_image_menu.dart';

class InputMethodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Button Image Menu'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 2.1,
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
                      onPress: () {
                        // Navigator.pushNamed(context, Routes.barCodeTypePage);
                      },
                    ),
                    ButtonImageMenu(
                      imageOn: 'top_find_car_on.png',
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
        ),
      ),
    );
  }
}
