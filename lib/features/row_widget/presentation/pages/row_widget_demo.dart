import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_1.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_2.dart';

import '../../../../core/widgets/row_widget/row_widget_pattern_10.dart';
import '../../../../core/widgets/row_widget/row_widget_pattern_5.dart';
import '../../../../core/widgets/row_widget/row_widget_pattern_6.dart';
import '../../../../core/widgets/row_widget/row_widget_pattern_7.dart';
import '../../../../core/widgets/row_widget/row_widget_pattern_8.dart';
import '../../../../core/widgets/row_widget/row_widget_pattern_9.dart';

class RowWidgetPage extends StatefulWidget {
  @override
  RowWidgetState createState() => RowWidgetState();
}

class RowWidgetState extends State<RowWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        appBarTitle: '共通Widget',
        body: SingleChildScrollView(
            child: Column(
          children: [
            RowWidgetPattern1(
              mainTitle: 'アイシス',
              subTitle: '(100)',
              initValue: true,
              onCheckChanged: (value) => print('Check box value is : $value'),
            ),
            RowWidgetPattern2(title: 'お名前', value: 'すずき'),
            RowWidgetPattern2(
              title: 'アプリバージョン',
              value: 'ver.1.2.13',
              textAlign: TextAlign.end,
            ),
            RowWidgetPattern5(
              requiredField: false,
              textStr: "POST_CODE".tr(),
              maxLines: 1,
              onTextChangeFirst: (String value) {
                print(
                    "[input_methob_page] Pattern5RowWidget onTextChangeFirst");
                print(value);
              },
              onTextChangeSecond: (String value) {
                print(
                    "[input_methob_page] Pattern5RowWidget onTextChangeSecond");
                print(value);
              },
            ),
            RowWidgetPattern6(
              textBtn: '入力なし',
              requiredField: false,
              textStr: "DOB".tr(),
              btnCallBack: () {
                print("[input_methob_page] Pattern6RowWidget btnCallBack");
              },
            ),
            RowWidgetPattern7(
              firstTextStr: "GENDER".tr(),
              firstTextBtn: '入力なし',
              secondTextStr: "FAMILY_STRUCTURE".tr(),
              secondTextBtn: 'UNSPECIFIED'.tr(),
              fistCallBack: () {
                print("[input_methob_page] Pattern7RowWidget fistCallBack");
              },
              secondCallBack: () {
                print("[input_methob_page] Pattern7RowWidget secondCallBack");
              },
            ),
            RowWidgetPattern8(
              listData: ["おはようございます。", 'さよなら'],
              requiredField: false,
              textStr: "所有自動車",
              textBtn: "車両追加",
              rowCallBack: () async {
                print("[input_methob_page] Pattern8RowWidget rowCallBack");
              },
            ),
            RowWidgetPattern9(
                fistCallBack: () {
                  print("[input_methob_page] Pattern8RowWidget fistCallBack");
                },
                firstTextStr: "メーカー",
                firstTextBtn: "PLEASE_SELECT_DOWN".tr()),
            RowWidgetPattern10(
              requiredField: false,
              textStr: "MILEAGE".tr(),
              onTextChange: (String value) {
                print("[input_methob_page] Pattern10RowWidget onTextChange");
              },
            ),
          ],
        )));
  }
}
