import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class DemoListButton extends StatefulWidget {
  @override
  DemoListButtonState createState() => DemoListButtonState();
}

class DemoListButtonState extends State<DemoListButton> {
  late List<dynamic> listData;
  var apiReturn = [
    MakerModel(makerCode: '010', makerName: 'トヨタ', numOfCarASOne: '15441'),
    MakerModel(makerCode: '011', makerName: 'ニッサン', numOfCarASOne: '9297'),
    MakerModel(makerCode: '012', makerName: 'ミツビシ', numOfCarASOne: '2306'),
    MakerModel(makerCode: '013', makerName: 'マツダ', numOfCarASOne: '3232'),
    MakerModel(makerCode: '014', makerName: 'イスズ', numOfCarASOne: '15441'),
    MakerModel(makerCode: '015', makerName: 'ホンダ', numOfCarASOne: '15441'),
    MakerModel(makerCode: '016', makerName: 'ダイハツ', numOfCarASOne: '15441'),
    MakerModel(makerCode: '017', makerName: 'スバル', numOfCarASOne: '15441'),
    MakerModel(makerCode: '018', makerName: 'スズキ', numOfCarASOne: '15441'),
    MakerModel(makerCode: '019', makerName: 'ミツオカ', numOfCarASOne: '15441'),
    MakerModel(makerCode: '020', makerName: 'レクサス', numOfCarASOne: '15441'),
    MakerModel(makerCode: '021', makerName: 'ヒノ', numOfCarASOne: '15441'),
    MakerModel(
        makerCode: '022', makerName: 'ニッサンディーゼル', numOfCarASOne: '15441'),
    MakerModel(makerCode: '023', makerName: 'ミツビシフソウ', numOfCarASOne: '15441'),
    MakerModel(
        makerCode: '050',
        makerName: '------(ドイツ)------',
        numOfCarASOne: '99999'),
    MakerModel(makerCode: '051', makerName: 'AMG', numOfCarASOne: '139'),
    MakerModel(numOfCarASOne: '1569', makerCode: '052', makerName: 'BMW'),
    MakerModel(numOfCarASOne: '16', makerCode: '053', makerName: 'BMWアルピナ'),
    MakerModel(numOfCarASOne: '857', makerCode: '054', makerName: 'アウディ'),
    MakerModel(numOfCarASOne: '3', makerCode: '056', makerName: 'オペル'),
    MakerModel(numOfCarASOne: '88', makerCode: '057', makerName: 'スマート'),
    MakerModel(numOfCarASOne: '1062', makerCode: '058', makerName: 'フォルクスワーゲン'),
    MakerModel(numOfCarASOne: '1421', makerCode: '060', makerName: 'メルセデスベンツ'),
    MakerModel(numOfCarASOne: '417', makerCode: '061', makerName: 'ポルシェ'),
    MakerModel(numOfCarASOne: '843', makerCode: '064', makerName: 'ミニ'),
    MakerModel(
        numOfCarASOne: '99999', makerCode: '070', makerName: '---(スウェーデン)---'),
    MakerModel(numOfCarASOne: '1', makerCode: '071', makerName: 'サーブ'),
    MakerModel(numOfCarASOne: '392', makerCode: '072', makerName: 'ボルボ'),
    MakerModel(
        numOfCarASOne: '99999',
        makerCode: '080',
        makerName: '-----(フランス)-----'),
    MakerModel(numOfCarASOne: '165', makerCode: '081', makerName: 'シトロエン'),
    MakerModel(numOfCarASOne: '280', makerCode: '082', makerName: 'プジョー'),
    MakerModel(numOfCarASOne: '158', makerCode: '083', makerName: 'ルノー'),
    MakerModel(
        numOfCarASOne: '99999',
        makerCode: '090',
        makerName: '-----(アメリカ)-----'),
    MakerModel(numOfCarASOne: '12', makerCode: '092', makerName: 'GMC'),
    MakerModel(numOfCarASOne: '92', makerCode: '095', makerName: 'キャデラック'),
    MakerModel(numOfCarASOne: '55', makerCode: '096', makerName: 'クライスラー'),
    MakerModel(numOfCarASOne: '2', makerCode: '098', makerName: 'サリーン'),
    MakerModel(numOfCarASOne: '149', makerCode: '099', makerName: 'シボレー'),
    MakerModel(numOfCarASOne: '63', makerCode: '100', makerName: 'ダッジ'),
    MakerModel(numOfCarASOne: '33', makerCode: '101', makerName: 'ハマー'),
    MakerModel(numOfCarASOne: '1', makerCode: '102', makerName: 'ビュイック'),
    MakerModel(numOfCarASOne: '121', makerCode: '103', makerName: 'フォード'),
    MakerModel(numOfCarASOne: '1', makerCode: '104', makerName: 'プリムス'),
    MakerModel(numOfCarASOne: '3', makerCode: '105', makerName: 'ポンテアック'),
    MakerModel(numOfCarASOne: '3', makerCode: '106', makerName: 'マーキュリー'),
    MakerModel(numOfCarASOne: '20', makerCode: '107', makerName: 'リンカーン'),
    MakerModel(numOfCarASOne: '335', makerCode: '108', makerName: 'ジープ'),
    MakerModel(
        numOfCarASOne: '99999',
        makerCode: '110',
        makerName: '-----(イギリス)-----'),
    MakerModel(numOfCarASOne: '1', makerCode: '112', makerName: 'MG'),
    MakerModel(numOfCarASOne: '1', makerCode: '113', makerName: 'TVR'),
    MakerModel(numOfCarASOne: '28', makerCode: '114', makerName: 'アストンマーティン'),
    MakerModel(numOfCarASOne: '1', makerCode: '117', makerName: 'オースチン'),
    MakerModel(numOfCarASOne: '1', makerCode: '118', makerName: 'ケーターハム'),
    MakerModel(numOfCarASOne: '161', makerCode: '119', makerName: 'ジャガー'),
    MakerModel(numOfCarASOne: '13', makerCode: '120', makerName: 'デイムラー'),
    MakerModel(numOfCarASOne: '1', makerCode: '122', makerName: 'バンデンプラ'),
    MakerModel(numOfCarASOne: '1', makerCode: '123', makerName: 'パンサー'),
    MakerModel(numOfCarASOne: '47', makerCode: '125', makerName: 'ベントレー'),
    MakerModel(numOfCarASOne: '1', makerCode: '128', makerName: 'モーリス'),
    MakerModel(numOfCarASOne: '146', makerCode: '130', makerName: 'ランドローバー'),
    MakerModel(numOfCarASOne: '6', makerCode: '131', makerName: 'ロータス'),
    MakerModel(numOfCarASOne: '25', makerCode: '132', makerName: 'ローバー'),
    MakerModel(numOfCarASOne: '20', makerCode: '133', makerName: 'ロールスロイス'),
    MakerModel(
        numOfCarASOne: '99999',
        makerCode: '150',
        makerName: '-----(イタリア)-----'),
    MakerModel(numOfCarASOne: '122', makerCode: '152', makerName: 'アルファロメオ'),
    MakerModel(numOfCarASOne: '368', makerCode: '155', makerName: 'フィアット'),
    MakerModel(numOfCarASOne: '65', makerCode: '156', makerName: 'フェラーリ'),
    MakerModel(numOfCarASOne: '96', makerCode: '158', makerName: 'マセラティ'),
    MakerModel(numOfCarASOne: '2', makerCode: '159', makerName: 'ランチア'),
    MakerModel(numOfCarASOne: '23', makerCode: '160', makerName: 'ランボルギーニ'),
    MakerModel(
        numOfCarASOne: '99999', makerCode: '180', makerName: '-----(韓国)-----'),
    MakerModel(numOfCarASOne: '1', makerCode: '183', makerName: 'キア'),
    MakerModel(numOfCarASOne: '6', makerCode: '184', makerName: 'サンヨン'),
    MakerModel(
        numOfCarASOne: '99999', makerCode: '300', makerName: '----------'),
    MakerModel(numOfCarASOne: '97', makerCode: '901', makerName: '逆輸入車'),
    MakerModel(numOfCarASOne: '159', makerCode: '999', makerName: 'OTHERS'.tr())
  ];
  late Map<String, List<MakerModel>> groupData;
  late List<GlobalKey> keys;
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    var groupName = 'JAPAN'.tr();
    List<MakerModel> listData = [];
    keys = <GlobalKey>[];
    keys.add(GlobalKey());
    groupData = {};
    // Convert Api Data to List Button can use data
    for (var i = 0; i < apiReturn.length; i++) {
      if (apiReturn[i].numOfCarASOne == '99999' ||
          apiReturn[i].makerName == '----------') {
        groupData.addAll({groupName: listData});
        var replaceName = apiReturn[i].makerName.replaceAll('-', '');
        replaceName = replaceName.replaceAll('(', '');
        replaceName = replaceName.replaceAll(')', '');
        groupName = replaceName;
        if (groupName.isEmpty) {
          groupName = 'OTHERS'.tr();
        }
        listData = [];
        keys.add(GlobalKey());
      } else {
        listData.add(apiReturn[i]);
      }
    }
    if (apiReturn[apiReturn.length - 1].numOfCarASOne != '99999') {
      groupData.addAll({groupName: listData});
      keys.add(GlobalKey());
    }
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarTitle: 'リストボタンWidget',
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildLeftSideButton(),
          ),
          Expanded(
            flex: 1,
            child: _buildRightSideButton(),
          )
        ],
      ),
    );
  }

  Widget _buildLeftSideButton() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: true,
      hoverThickness: 0.0,
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildGroupList(),
        ),
      ),
    );
  }

  Widget _buildRightSideButton() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildMenuScroll(),
      ),
    );
  }

  List<Widget> _buildGroupList() {
    List<Widget> listWidget = [];
    for (var item in groupData.entries) {
      var index = groupData.keys.toList().indexOf(item.key);
      listWidget.add(_buildGroupHeader(item.key, index));
      listWidget.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildGroupDetail(item.value),
      ));
    }
    return listWidget;
  }

  Container _buildGroupHeader(String title, int index) {
    return Container(
      key: keys[index],
      width: double.maxFinite,
      decoration: BoxDecoration(color: Colors.grey),
      child: TextWidget(
        label: title,
      ),
    );
  }

  List<Widget> _buildGroupDetail(List<MakerModel> listData) {
    List<Widget> listWidget = [];
    for (var item in listData) {
      listWidget.add(TextButton(
          onPressed: () => Navigator.pop(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                label: item.makerName,
              ),
              TextWidget(
                  label: '(${item.numOfCarASOne})',
                  textStyle: MKStyle.t12R.copyWith(
                    color: ResourceColors.grey,
                  ))
            ],
          )));
    }
    return listWidget;
  }

  List<Widget> _buildMenuScroll() {
    List<Widget> listWidget = [];
    for (var item in groupData.entries) {
      listWidget.add(TextButton(
        onPressed: () => changePosition(item.key),
        child: TextWidget(
            label: item.key,
            textStyle: MKStyle.t12R.copyWith(
              color: ResourceColors.color_white,
            )),
      ));
    }
    return listWidget;
  }

  void changePosition(String key) {
    var index = groupData.keys.toList().indexOf(key);
    var renderObject = keys[index].currentContext?.findRenderObject();
    if (renderObject != null) {
      controller.position
          .ensureVisible(renderObject, duration: Duration(milliseconds: 300));
    }
  }
}

class MakerModel {
  final String makerCode;
  final String makerName;
  final String numOfCarASOne;

  MakerModel(
      {this.makerCode = '', this.makerName = '', this.numOfCarASOne = ''});
}

class MakerModelType2 {
  final String makerCode;
  final String makerName;
  final String numOfCarASOne;
  final String carGroup;
  final String asnetCarCode;

  MakerModelType2(
      {this.makerCode = '',
      this.makerName = '',
      this.numOfCarASOne = '',
      this.carGroup = '',
      this.asnetCarCode = ''});
}

var apiReturnMakerList = [
  MakerModel(makerCode: '010', makerName: 'トヨタ', numOfCarASOne: '15441'),
  MakerModel(makerCode: '011', makerName: 'ニッサン', numOfCarASOne: '9297'),
  MakerModel(makerCode: '012', makerName: 'ミツビシ', numOfCarASOne: '2306'),
  MakerModel(makerCode: '013', makerName: 'マツダ', numOfCarASOne: '3232'),
  MakerModel(makerCode: '014', makerName: 'イスズ', numOfCarASOne: '15441'),
  MakerModel(makerCode: '015', makerName: 'ホンダ', numOfCarASOne: '15441'),
  MakerModel(makerCode: '016', makerName: 'ダイハツ', numOfCarASOne: '15441'),
  MakerModel(makerCode: '017', makerName: 'スバル', numOfCarASOne: '15441'),
  MakerModel(makerCode: '018', makerName: 'スズキ', numOfCarASOne: '15441'),
  MakerModel(makerCode: '019', makerName: 'ミツオカ', numOfCarASOne: '15441'),
  MakerModel(makerCode: '020', makerName: 'レクサス', numOfCarASOne: '15441'),
  MakerModel(makerCode: '021', makerName: 'ヒノ', numOfCarASOne: '15441'),
  MakerModel(makerCode: '022', makerName: 'ニッサンディーゼル', numOfCarASOne: '15441'),
  MakerModel(makerCode: '023', makerName: 'ミツビシフソウ', numOfCarASOne: '15441'),
  MakerModel(
      makerCode: '050', makerName: '------(ドイツ)------', numOfCarASOne: '99999'),
  MakerModel(makerCode: '051', makerName: 'AMG', numOfCarASOne: '139'),
  MakerModel(numOfCarASOne: '1569', makerCode: '052', makerName: 'BMW'),
  MakerModel(numOfCarASOne: '16', makerCode: '053', makerName: 'BMWアルピナ'),
  MakerModel(numOfCarASOne: '857', makerCode: '054', makerName: 'アウディ'),
  MakerModel(numOfCarASOne: '3', makerCode: '056', makerName: 'オペル'),
  MakerModel(numOfCarASOne: '88', makerCode: '057', makerName: 'スマート'),
  MakerModel(numOfCarASOne: '1062', makerCode: '058', makerName: 'フォルクスワーゲン'),
  MakerModel(numOfCarASOne: '1421', makerCode: '060', makerName: 'メルセデスベンツ'),
  MakerModel(numOfCarASOne: '417', makerCode: '061', makerName: 'ポルシェ'),
  MakerModel(numOfCarASOne: '843', makerCode: '064', makerName: 'ミニ'),
  MakerModel(
      numOfCarASOne: '99999', makerCode: '070', makerName: '---(スウェーデン)---'),
  MakerModel(numOfCarASOne: '1', makerCode: '071', makerName: 'サーブ'),
  MakerModel(numOfCarASOne: '392', makerCode: '072', makerName: 'ボルボ'),
  MakerModel(
      numOfCarASOne: '99999', makerCode: '080', makerName: '-----(フランス)-----'),
  MakerModel(numOfCarASOne: '165', makerCode: '081', makerName: 'シトロエン'),
  MakerModel(numOfCarASOne: '280', makerCode: '082', makerName: 'プジョー'),
  MakerModel(numOfCarASOne: '158', makerCode: '083', makerName: 'ルノー'),
  MakerModel(
      numOfCarASOne: '99999', makerCode: '090', makerName: '-----(アメリカ)-----'),
  MakerModel(numOfCarASOne: '12', makerCode: '092', makerName: 'GMC'),
  MakerModel(numOfCarASOne: '92', makerCode: '095', makerName: 'キャデラック'),
  MakerModel(numOfCarASOne: '55', makerCode: '096', makerName: 'クライスラー'),
  MakerModel(numOfCarASOne: '2', makerCode: '098', makerName: 'サリーン'),
  MakerModel(numOfCarASOne: '149', makerCode: '099', makerName: 'シボレー'),
  MakerModel(numOfCarASOne: '63', makerCode: '100', makerName: 'ダッジ'),
  MakerModel(numOfCarASOne: '33', makerCode: '101', makerName: 'ハマー'),
  MakerModel(numOfCarASOne: '1', makerCode: '102', makerName: 'ビュイック'),
  MakerModel(numOfCarASOne: '121', makerCode: '103', makerName: 'フォード'),
  MakerModel(numOfCarASOne: '1', makerCode: '104', makerName: 'プリムス'),
  MakerModel(numOfCarASOne: '3', makerCode: '105', makerName: 'ポンテアック'),
  MakerModel(numOfCarASOne: '3', makerCode: '106', makerName: 'マーキュリー'),
  MakerModel(numOfCarASOne: '20', makerCode: '107', makerName: 'リンカーン'),
  MakerModel(numOfCarASOne: '335', makerCode: '108', makerName: 'ジープ'),
  MakerModel(
      numOfCarASOne: '99999', makerCode: '110', makerName: '-----(イギリス)-----'),
  MakerModel(numOfCarASOne: '1', makerCode: '112', makerName: 'MG'),
  MakerModel(numOfCarASOne: '1', makerCode: '113', makerName: 'TVR'),
  MakerModel(numOfCarASOne: '28', makerCode: '114', makerName: 'アストンマーティン'),
  MakerModel(numOfCarASOne: '1', makerCode: '117', makerName: 'オースチン'),
  MakerModel(numOfCarASOne: '1', makerCode: '118', makerName: 'ケーターハム'),
  MakerModel(numOfCarASOne: '161', makerCode: '119', makerName: 'ジャガー'),
  MakerModel(numOfCarASOne: '13', makerCode: '120', makerName: 'デイムラー'),
  MakerModel(numOfCarASOne: '1', makerCode: '122', makerName: 'バンデンプラ'),
  MakerModel(numOfCarASOne: '1', makerCode: '123', makerName: 'パンサー'),
  MakerModel(numOfCarASOne: '47', makerCode: '125', makerName: 'ベントレー'),
  MakerModel(numOfCarASOne: '1', makerCode: '128', makerName: 'モーリス'),
  MakerModel(numOfCarASOne: '146', makerCode: '130', makerName: 'ランドローバー'),
  MakerModel(numOfCarASOne: '6', makerCode: '131', makerName: 'ロータス'),
  MakerModel(numOfCarASOne: '25', makerCode: '132', makerName: 'ローバー'),
  MakerModel(numOfCarASOne: '20', makerCode: '133', makerName: 'ロールスロイス'),
  MakerModel(
      numOfCarASOne: '99999', makerCode: '150', makerName: '-----(イタリア)-----'),
  MakerModel(numOfCarASOne: '122', makerCode: '152', makerName: 'アルファロメオ'),
  MakerModel(numOfCarASOne: '368', makerCode: '155', makerName: 'フィアット'),
  MakerModel(numOfCarASOne: '65', makerCode: '156', makerName: 'フェラーリ'),
  MakerModel(numOfCarASOne: '96', makerCode: '158', makerName: 'マセラティ'),
  MakerModel(numOfCarASOne: '2', makerCode: '159', makerName: 'ランチア'),
  MakerModel(numOfCarASOne: '23', makerCode: '160', makerName: 'ランボルギーニ'),
  MakerModel(
      numOfCarASOne: '99999', makerCode: '180', makerName: '-----(韓国)-----'),
  MakerModel(numOfCarASOne: '1', makerCode: '183', makerName: 'キア'),
  MakerModel(numOfCarASOne: '6', makerCode: '184', makerName: 'サンヨン'),
  MakerModel(numOfCarASOne: '99999', makerCode: '300', makerName: '----------'),
  MakerModel(numOfCarASOne: '97', makerCode: '901', makerName: '逆輸入車'),
  MakerModel(numOfCarASOne: '159', makerCode: '999', makerName: 'OTHERS'.tr())
];

var apiReturn = [
  MakerModelType2(makerCode: '014', carGroup: 'アイシス', numOfCarASOne: '100'),
  MakerModelType2(makerCode: '022', carGroup: 'アクア', numOfCarASOne: '932'),
  MakerModelType2(makerCode: '023', carGroup: 'アベンシス', numOfCarASOne: '5'),
  MakerModelType2(makerCode: '014', carGroup: 'アベンシスワゴン', numOfCarASOne: '19'),
  MakerModelType2(makerCode: '016', carGroup: 'アリオン', numOfCarASOne: '17'),
  MakerModelType2(makerCode: '016', carGroup: 'アリスト', numOfCarASOne: '31'),
  MakerModelType2(makerCode: '016', carGroup: 'アルテッツァ', numOfCarASOne: '35'),
  MakerModelType2(makerCode: '016', carGroup: 'アルテッツァジータ', numOfCarASOne: '2'),
  MakerModelType2(makerCode: '016', carGroup: 'ヴォクシー', numOfCarASOne: '514'),
  MakerModelType2(makerCode: '016', carGroup: 'エスクァイア', numOfCarASOne: '149'),
  MakerModelType2(makerCode: '016', carGroup: 'オーパ', numOfCarASOne: '1'),
  MakerModelType2(makerCode: '016', carGroup: 'オリジン', numOfCarASOne: '7'),
  MakerModelType2(makerCode: '016', carGroup: 'カムリ', numOfCarASOne: '93'),
  MakerModelType2(makerCode: '016', carGroup: 'カローラ', numOfCarASOne: '29'),
  MakerModelType2(makerCode: '022', carGroup: 'キャミ', numOfCarASOne: '1'),
  MakerModelType2(makerCode: '023', carGroup: 'クイックデリバリー', numOfCarASOne: '3'),
  MakerModelType2(makerCode: '023', carGroup: 'クラウン', numOfCarASOne: '289'),
  MakerModelType2(makerCode: '023', carGroup: 'グランビア', numOfCarASOne: '2'),
  MakerModelType2(makerCode: '023', carGroup: 'コースター', numOfCarASOne: '170'),
  MakerModelType2(makerCode: '023', carGroup: 'コペン', numOfCarASOne: '5'),
  MakerModelType2(makerCode: '023', carGroup: 'サイノス', numOfCarASOne: '1'),
  MakerModelType2(makerCode: '014', carGroup: 'サクシードバン', numOfCarASOne: '143'),
  MakerModelType2(makerCode: '016', carGroup: 'シエンタ', numOfCarASOne: '328'),
  MakerModelType2(makerCode: '022', carGroup: 'スープラ', numOfCarASOne: '39'),
  MakerModelType2(makerCode: '023', carGroup: 'セリカ', numOfCarASOne: '50'),
  MakerModelType2(makerCode: '023', carGroup: 'ソアラ', numOfCarASOne: '58'),
  MakerModelType2(
      makerCode: '023', carGroup: 'OTHERS'.tr(), numOfCarASOne: '124'),
  MakerModelType2(makerCode: '024', carGroup: 'ターセル', numOfCarASOne: '1'),
  MakerModelType2(makerCode: '024', carGroup: 'ダイナ', numOfCarASOne: '367'),
  MakerModelType2(makerCode: '024', carGroup: 'チェイサー', numOfCarASOne: '47'),
  MakerModelType2(makerCode: '024', carGroup: 'デュエット', numOfCarASOne: '1'),
  MakerModelType2(makerCode: '024', carGroup: 'トヨエース', numOfCarASOne: '205'),
  MakerModelType2(makerCode: '024', carGroup: 'ナディア', numOfCarASOne: '1'),
  MakerModelType2(makerCode: '024', carGroup: 'ノア', numOfCarASOne: '325'),
  MakerModelType2(makerCode: '024', carGroup: 'ハイラックス', numOfCarASOne: '113'),
  MakerModelType2(makerCode: '024', carGroup: 'パッソ', numOfCarASOne: '414'),
  MakerModelType2(makerCode: '024', carGroup: 'パブリカ', numOfCarASOne: '2'),
  MakerModelType2(makerCode: '024', carGroup: 'ピクシスエポック', numOfCarASOne: '70'),
  MakerModelType2(makerCode: '024', carGroup: 'ファンカーゴ', numOfCarASOne: '8'),
  MakerModelType2(makerCode: '024', carGroup: 'プラッソ', numOfCarASOne: '1'),
  MakerModelType2(makerCode: '024', carGroup: 'ブリザード', numOfCarASOne: '2'),
  MakerModelType2(makerCode: '024', carGroup: 'ベルタ', numOfCarASOne: '5'),
  MakerModelType2(makerCode: '024', carGroup: 'ポルテ', numOfCarASOne: '182'),
  MakerModelType2(makerCode: '024', carGroup: '86', numOfCarASOne: '294'),
  MakerModelType2(makerCode: '024', carGroup: 'bB', numOfCarASOne: '120'),
  MakerModelType2(makerCode: '024', carGroup: 'C-HR', numOfCarASOne: '258'),
];
