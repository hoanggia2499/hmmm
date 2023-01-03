import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirukuru/core/config/app_properties.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:mirukuru/main_common.dart';

void main() {
  testWidgets("Flutter Widget Test button login", (WidgetTester tester) async {
    //init maincommon
    tester.runAsync(() async {
      await mainCommon(AppProperties(
        apSrvURL: 'http://192.168.200.114:8888',
        imgSrvURL: 'http://192.168.200.114',
        isDebugMode: true,
      ));
    });
    bool checkLogin = false;

    /// Build the Widget that you need to test.
    /// This Widget should be as small as possible so that you don't have to account for other widgets
    await tester.pumpWidget(
      Builder(builder: (_) {
        return MaterialApp(
          home: ButtonWidget(
            clickButtonCallBack: () {
              checkLogin = true;
            },
            content: 'SIGN_UP'.tr(),
          ),
        );
      }),
    );

    /// Define Finders for the parts of your widget you want to interact with
    final titleFinder = find.text('SIGN_UP'.tr());
    final widgetFinder = find.byType(ElevatedButton);
    expect(checkLogin, false);

    ///Interact with the widget
    await tester.tap(widgetFinder);

    /// Call pump() to update the widget and process the action
    await tester.pump();

    /// Expect results
    expect(checkLogin, true);
    expect(titleFinder, findsOneWidget);
  });
}
