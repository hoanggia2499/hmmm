import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/dimens.dart';
import 'package:mirukuru/core/widgets/common/sub_title_widget.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/model/pattern23_model.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_14.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_15.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_16.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_19.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_13.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_20.dart';
import '../../../../core/widgets/row_widget/row_widget_pattern_11.dart';

class RowWidgetPage2 extends StatefulWidget {
  @override
  RowWidgetState2 createState() => RowWidgetState2();
}

class RowWidgetState2 extends State<RowWidgetPage2> {
  List<String> listData = ["見積依頼", "来店予約", "車両問い合わせ"];
  List<Pattern23Model> listPattern23 = [
    Pattern23Model(
        contentBottom: "ffffccccccccccccccccccc",
        contentTop: "ffff",
        isRead: true),
    Pattern23Model(
        contentBottom: "ffff",
        contentTop:
            "ffffdddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
        isRead: false),
    Pattern23Model(contentBottom: "ffff", contentTop: "ffff", isRead: false),
    Pattern23Model(contentBottom: "ffff", contentTop: "ffff", isRead: false)
  ];

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        appBarTitle: '共通Widget',
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                RowWidgetPattern11(
                  cancelTitle: 'CANCEL'.tr(),
                  cancelPress: () => print('Cancel button is pressed'),
                  okTitle: '登録',
                  okPress: () => print('Ok button is pressed'),
                ),
                // RowWidgetPattern12(listData: [
                //   'トヨタ アイシス',
                //   'トヨタ アクア',
                //   'トヨタ アベンシス',
                //   'トヨタ アベンシスワゴン'
                // ]),
                RowWidgetPattern13(
                  title: 'MODEL_YEAR_HISTORY'.tr(),
                  onStartPress: () => print('Tapped Start Button'),
                  onEndPress: () => print('Tapped End Button'),
                ),
                RowWidgetPattern14(
                  iconButtonLeft: "assets/images/png/okiniiri_icon.png",
                  iconButtonRight: "assets/images/png/mitsumori_icon.png",
                  callbackBtnLeft: () {
                    print(
                        "[row_widget_demo2] Pattern15RowWidget callbackBtnLeft");
                  },
                  callbackBtnRight: () {
                    print(
                        "[row_widget_demo2] Pattern15RowWidget callbackBtnRight");
                  },
                ),
                RowWidgetPattern15(
                    listData: listData,
                    radioCallBack: (int index) {
                      print(
                          "[row_widget_demo2] Pattern16RowWidget radioCallBack");
                    }),
                RowWidgetPattern16(initValue: ""),
                RowWidgetPattern19(
                  contentTop: "500-154360805 トヨタ アイシス",
                  contentBottom: "2022年１2月3日",
                  iconUrl: 'assets/images/png/mitsumori_irai_icon.png',
                ),
                RowWidgetPattern19(
                  contentTop: "500-154360805 トヨタ アイシス",
                  contentBottom: "2022年１2月3日",
                  iconUrl: 'assets/images/png/sharyo_toiawase_icon.png',
                ),
                RowWidgetPattern19(
                  contentTop: "500-154360805 トヨタ アイシス",
                  contentBottom: "2022年１2月3日",
                  iconUrl: 'assets/images/png/sonota_icon.png',
                ),
                RowWidgetPattern19(
                  contentTop: "500-154360805 トヨタ アイシス",
                  contentBottom: "2022年１2月3日",
                  iconUrl: 'assets/images/png/raitenyoyaku_icon.png',
                ),
                RowWidgetPattern20(
                  textStr: 'WHOLE_COUNTRY'.tr(),
                  content:
                      '${"WHOLE_COUNTRY".tr()},北海道,東北,青森県,秋田県,岩手県,山形県,宮城県,福島県,関東,群馬県,栃木県,茨城県,埼玉県,東京都,千葉県,神奈川県,甲信越・北陸,新潟県,新潟県,長野県,山梨県,富山県,石川県,福井県,東海,静岡県,岐阜県,愛知県,三重県,中国,鳥取県,岡山県,島根県,広島県,山口県,四国,愛媛県,香川県,高知県,徳島県,九州,長崎県,佐賀県,福岡県,熊本県,大分県,宮崎県,鹿児島県,沖縄県,',
                  rowCallBack: () {},
                ),
                SizedBox(
                  height: Dimens.getHeight(10.0),
                ),
                // Sub title
                // Subtitle(label: 'お気に入り'),
                SubTitle(label: 'FAVORITE'.tr()),
              ],
            ),
          ),
        ));
  }
}
