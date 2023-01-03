import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/dimens.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_22.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_23.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_24.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_25.dart';

class RowWidgetPage3 extends StatefulWidget {
  @override
  _RowWidgetPage3State createState() => _RowWidgetPage3State();
}

class _RowWidgetPage3State extends State<RowWidgetPage3> {
  var isCheckRow21_1 = false;
  var isCheckRow21_2 = false;
  var isCheckRow21_3 = false;
  var isCheckRow21_4 = false;
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        appBarTitle: '共通Widget',
        body: SingleChildScrollView(
            child: Column(
          children: [
            // // Patter 21
            // RowWidgetPattern21(
            //   contentTop: '500-154360805 ト\nヨタ アイシス',
            //   contentBottom: '2022年１2月3日',
            //   isCheck: isCheckRow21_1,
            //   onCheckChange: (value) => onCheckChange(value, 1),
            //   icon: 'assets/images/png/mitsumori_irai_icon.png',
            // ),
            // RowWidgetPattern21(
            //   contentTop: '500-154360805 ト\nヨタ アイシス',
            //   contentBottom: '2022年１2月3日',
            //   isCheck: isCheckRow21_2,
            //   onCheckChange: (value) => onCheckChange(value, 2),
            //   icon: 'assets/images/png/sharyo_toiawase_icon.png',
            // ),
            // RowWidgetPattern21(
            //   contentTop: '500-154360805 ト\nヨタ アイシス',
            //   contentBottom: '2022年１2月3日',
            //   isCheck: isCheckRow21_3,
            //   onCheckChange: (value) => onCheckChange(value, 3),
            //   icon: 'assets/images/png/sonota_icon.png',
            // ),
            // RowWidgetPattern21(
            //   contentTop: '500-154360805 ト\nヨタ アイシス',
            //   contentBottom: '2022年１2月3日',
            //   isCheck: isCheckRow21_4,
            //   onCheckChange: (value) => onCheckChange(value, 4),
            //   icon: 'assets/images/png/raitenyoyaku_icon.png',
            // ),
            SizedBox(
              height: Dimens.getHeight(8.0),
            ),
            // Patter 22
            RowWidgetPattern22(
              textBtnLeft: '並び順',
              textBtnCenter: 'DELETE'.tr(),
              textBtnRight: '新規問い合わせ',
              onClickBtnLeft: () => print('Button Left Clicked'),
              onClickBtnCenter: () => print('Button Center Clicked'),
              onClickBtnRight: () => print('Button Right Clicked'),
              editFlag: false,
            ),
            SizedBox(
              height: Dimens.getHeight(8.0),
            ),
            RowWidgetPattern22(
              textBtnLeft: '並び順',
              textBtnCenter: '編集',
              textBtnRight: '新規問い合わせ',
              onClickBtnLeft: () => print('Button Left Clicked'),
              onClickBtnCenter: () => print('Button Center Clicked'),
              onClickBtnRight: () => print('Button Right Clicked'),
            ),
            SizedBox(
              height: Dimens.getHeight(10.0),
            ),
            RowWidgetPattern23(
              contentTop: '返信：車両問合せ：500-1554360804',
              contentBottom: '2022年3月10日 08:48',
              isReaded: true,
            ),
            RowWidgetPattern23(
              contentTop: '返信：見積依頼：500-1554360804',
              contentBottom: '2022年3月14日 11:31',
            ),
            RowWidgetPattern23(
              contentTop: '返信：その他：',
              contentBottom: '2022年3月10日 11:43',
            ),
            RowWidgetPattern23(
              contentTop: '返信：車両問合せ：500-1L38260004',
              contentBottom: '2022年3月10日 11:36',
            ),
            RowWidgetPattern24(
              txtLeft: '2022/03/14\n11:36',
              txtRight:
                  'ご質問ありがとうございます。\nいつでも来店できるので、ご遠慮なくご連絡ください。\nよろしくお願いします。',
            ),
            RowWidgetPattern24(
              txtLeft: '2022/03/14\n09:27',
              txtRight: 'いつ来店できますか',
            ),
            SizedBox(
              height: Dimens.getHeight(10.0),
            ),
            RowWidgetPattern25(),
          ],
        )));
  }

  void onCheckChange(bool value, int index) {
    setState(() {
      switch (index) {
        case 1:
          isCheckRow21_1 = value;
          break;
        case 2:
          isCheckRow21_2 = value;
          break;
        case 3:
          isCheckRow21_3 = value;
          break;
        case 4:
          isCheckRow21_4 = value;
          break;
      }
    });
  }
}
