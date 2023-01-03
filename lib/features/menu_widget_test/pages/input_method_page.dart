import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/row_widget/common/item_date_time.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:mirukuru/features/row_widget/presentation/pages/list_button_pattern_3.dart';
import 'package:mirukuru/features/row_widget/presentation/pages/list_template.dart';
import 'package:mirukuru/features/row_widget/presentation/pages/row_widget_demo.dart';
import 'package:mirukuru/features/row_widget/presentation/pages/row_widget_demo3.dart';
import 'package:mirukuru/features/search_top/presentation/pages/search_top_page.dart';

import '../../../core/widgets/dialog/common_dialog.dart';
import '../../login/presentation/pages/login_page.dart';
import '../../row_widget/presentation/pages/row_widget_demo2.dart';
import '../../row_widget/presentation/pages/row_widget_demo4.dart';

class MenuWidgetTestPage extends StatefulWidget {
  MenuWidgetTestPage({Key? key}) : super(key: key);

  @override
  _MenuWidgetTestPage createState() => _MenuWidgetTestPage();
}

class _MenuWidgetTestPage extends State<MenuWidgetTestPage> {
  List<String> listData = ['入力なし', '男性', '女性', '法人'];
  TextStyle textStyle =
      MKStyle.t16R.copyWith(color: ResourceColors.color_FFFFFF);
  var now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu Widget Test'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ButtonWidget(
              //     content: '2. List Button Widget Pattern 1',
              //     textColor: ResourceColors.color_FFFFFF,
              //     bgdColor: ResourceColors.color_FF1767ED,
              //     clickButtonCallBack: () async {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => ListViewCategoryPage()));
              //       //builder: (context) => DemoListButton()));
              //     }),
              // ButtonWidget(
              //     content: '3. List Button Widget Pattern 2',
              //     textColor: ResourceColors.color_FFFFFF,
              //     bgdColor: ResourceColors.color_FF1767ED,
              //     clickButtonCallBack: () async {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => ListViewPattern2()));
              //       //builder: (context) => DemoListButton()));
              //     }),
              ButtonWidget(
                  content: '4. List Button Widget Pattern 3',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListButtonPattern3(
                                  callBackArea: (value) {},
                                )));
                    //builder: (context) => DemoListButton()));
                  }),
              ButtonWidget(
                  content: '5. Row Widget Pattern 1 - 10',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RowWidgetPage()));
                  }),
              ButtonWidget(
                  content: '6. Row Widget Pattern 11 - 20',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RowWidgetPage2()));
                  }),
              ButtonWidget(
                  content: '7. Row Widget Pattern 21 - 25',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RowWidgetPage3()));
                  }),
              ButtonWidget(
                  content: '8. Dialog Confirm Widget',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    await CommonDialog.displayConfirmDialog(
                      context,
                      Text(
                        '発信します。宜しいですか？\n8888008248 ８２４８モータース',
                        style: textStyle,
                        textAlign: TextAlign.start,
                      ),
                      'OK',
                      'Cancel',
                      okEvent: () async {
                        print('OKOKOKOk');
                      },
                      cancelEvent: () {
                        print('CANCEL');
                      },
                    );
                  }),
              ButtonWidget(
                  content: '9. Dialog Radio Widget',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    await CommonDialog.displayRadioButtonDialog(
                        context, listData, 0, (value) {
                      print('itemValue$value');
                    });
                  }),
              ButtonWidget(
                  content: '10. List Template',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListTemplate()));
                  }),
              ButtonWidget(
                  content: '11. Dialog Date Time',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    now = DateTime(now.year, now.month, now.day + 1);
                    print(DateFormat.yMMMd().format(DateTime.now()));
                    print(now.day);
                    print(now.year);
                    await CommonDialog.displayConfirmDialog(
                      context,
                      ItemDateTime(callBackDateTime: (DateTime dateTime) {
                        print("Current Day-month-year:");
                        print(dateTime.day);
                        print(dateTime.month);
                        print(dateTime.year);
                      }),
                      'OK',
                      'Cancel',
                      okEvent: () async {},
                      cancelEvent: () {},
                    );
                  }),
              ButtonWidget(
                  content: '12. Table Data Widget',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TableDataWidgetPage()));
                  }),
              ButtonWidget(
                  content: '13. Login Page',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }),
              ButtonWidget(
                  content: '14. Top Page',
                  textStyle:
                      MKStyle.t12R.copyWith(color: ResourceColors.color_FFFFFF),
                  bgdColor: ResourceColors.color_FF1767ED,
                  clickButtonCallBack: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchTopPage()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
