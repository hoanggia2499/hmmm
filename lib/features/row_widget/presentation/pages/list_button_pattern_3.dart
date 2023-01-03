import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/user_secure_storage.dart';
import 'package:mirukuru/core/widgets/common/custom_check_box.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/dialog/common_dialog.dart';
import 'package:mirukuru/features/menu_widget_test/pages/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/common/template_page.dart';
import '../../../../core/widgets/common/text_widget.dart';

class ListButtonPattern3 extends StatefulWidget {
  final Function(String)? callBackArea;

  ListButtonPattern3({required this.callBackArea});
  @override
  _ListButtonPattern3 createState() => _ListButtonPattern3();
}

class _ListButtonPattern3 extends State<ListButtonPattern3> {
  late List<ListButtonPT3Model> groupData = [];
  late List<GlobalKey> keys;
  late ScrollController controller;
  String area = '';
  int numbersOfChecked = 0;

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        appBarTitle: '地域選択',
        body: Stack(
          children: [
            Row(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: true,
                  child: ButtonWidget(
                    content: '選択',
                    borderRadius: 0,
                    clickButtonCallBack: () {
                      handleSelectBtn();
                    },
                    bgdColor: ResourceColors.color_FF4BC9FD,
                    borderColor: ResourceColors.color_FF4BC9FD,
                    textStyle: MKStyle.t18R
                        .copyWith(color: ResourceColors.color_FFFFFF),
                    heightText: 1.2,
                  ),
                )
              ],
            )
          ],
        ));
  }

  handleSelectBtn() async {
    String areaStr = getNumberOfChecked();

    if (numbersOfChecked == 0) {
      CommonDialog.displayDialog(context, "5MA014CE", "5MA014CE".tr(), false);
    } else {
      areaStr = areaStr.replaceAll("　", "");
      areaStr = areaStr.substring(1);
      // var areaReplace = areaStr
      //     .replaceAll("東北,", "")
      //     .replaceAll("関東,", "")
      //     .replaceAll("甲信越・北陸,", "")
      //     .replaceAll("東海,", "")
      //     .replaceAll("関西,", "")
      //     .replaceAll("中国,", "")
      //     .replaceAll("四国,", "")
      //     .replaceAll("九州,", "");

      // area = areaReplace;
      // saveArea(area);

      saveArea(areaStr);
    }
  }

  saveArea(String area) async {
    Navigator.pop(context);
    widget.callBackArea!.call(area);

    await UserSecureStorage.instance.setArea(area);
  }

  Widget _buildLeftSideButton() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: false,
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
      decoration: BoxDecoration(
        color: ResourceColors.color_3768CE,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildMenuScroll(),
      ),
    );
  }

  List<Widget> _buildGroupList() {
    List<Widget> listWidget = [];
    var groupId = 0;
    var groupIndex = 0;
    for (var item in groupData) {
      // Loop for Group only
      if (groupId == 0 || groupId != item.groupId) {
        // Add group header
        listWidget.add(_buildGroupHeader(item.groupName, groupIndex));
        // Get all group detail based on groupId
        groupId = item.groupId;
        var groupDetailList =
            groupData.where((element) => element.groupId == groupId).toList();
        listWidget.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildGroupDetail(groupDetailList),
        ));
        groupIndex += 1;
      }
    }
    return listWidget;
  }

  Container _buildGroupHeader(String title, int index) {
    return Container(
      padding: EdgeInsets.only(left: Dimens.getHeight(10.0)),
      key: keys[index],
      width: double.maxFinite,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
      child: TextWidget(
        label: title,
        textStyle: MKStyle.t16R,
      ),
    );
  }

  List<Widget> _buildGroupDetail(List<ListButtonPT3Model> listData) {
    List<Widget> listWidget = [];
    var lastIndex = listData.length - 1;
    var count = 0;
    for (var item in listData) {
      if (item.hasCheckBox) {
        listWidget.add(_buildRowCheckBox(item, count, lastIndex,
            isFinalRow: count == lastIndex));
      } else {
        // Build row which has no checkbox inside
        listWidget.add(
          Container(
            padding: EdgeInsets.only(left: Dimens.getHeight(5.0)),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () => saveArea(item.areaName),
              child: TextWidget(
                alignment: TextAlign.left,
                label: item.areaName,
                textStyle: MKStyle.t16R,
              ),
              style: ButtonStyle(
                alignment: Alignment.centerLeft, // <-- had to set alignment
              ),
            ),
          ),
        );
      }
      count++;
    }
    return listWidget;
  }

  List<Widget> _buildMenuScroll() {
    List<Widget> listWidget = [];
    var groupId = 0;
    for (var item in groupData) {
      if (groupId == 0 || groupId != item.groupId) {
        listWidget.add(
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ResourceColors.color_white,
                  width: 0.5,
                ),
              ),
            ),
            width: double.maxFinite,
            child: TextButton(
              onPressed: () => changePosition(item.groupId),
              child: TextWidget(
                label: item.groupName,
                textStyle:
                    MKStyle.t16R.copyWith(color: ResourceColors.color_white),
              ),
            ),
          ),
        );
        groupId = item.groupId;
      }
    }
    return listWidget;
  }

  void changePosition(int groupId) {
    var renderObject = keys[groupId].currentContext?.findRenderObject();
    if (renderObject != null) {
      controller.position
          .ensureVisible(renderObject, duration: Duration(milliseconds: 300));
    }
  }

  Widget _buildRowCheckBox(ListButtonPT3Model data, int index, int length,
      {bool isFinalRow = false}) {
    return Container(
      margin: EdgeInsets.only(
          top: index == 0 ? DimenFont.sp7 : 0.0,
          left: Dimens.getHeight(10.0),
          bottom: index == length ? DimenFont.sp7 : 0.0),
      child: InkWell(
          onTap: () => onCheckChanged(data.copyWith(value: !data.isChecked)),
          highlightColor: Colors.orange,
          splashColor: Colors.orange,
          child: Column(children: [
            Row(
              children: [
                // Add padding left to child item
                if (!data.isAreaCateory)
                  SizedBox(width: Dimens.getHeight(30.0)),
                _buildCheckBox(data),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    flex: 6,
                    child: TextWidget(
                      label: data.areaName,
                      textStyle: MKStyle.t16R,
                    ))
              ],
            ),
            Visibility(
                visible: !isFinalRow,
                child: DividerNoText(
                  indent: 0.0,
                  endIndent: 0.0,
                ))
          ])),
    );
  }

  Widget _buildCheckBox(ListButtonPT3Model data) {
    return CustomCheckbox(
      value: data.isChecked,
      onChange: (value) => onCheckChanged(data.copyWith(value: value)),
      selectedIconColor: Colors.green,
      borderColor: Colors.grey,
      size: DimenFont.sp28,
      iconSize: DimenFont.sp25,
    );
  }

  void onCheckChanged(ListButtonPT3Model data) {
    var index = groupData.indexWhere((element) =>
        element.groupId == data.groupId && element.areaId == data.areaId);
    if (index > -1) {
      if (data.groupName != data.areaName) {
        setState(() {
          groupData[index] = data;
        });
      } else {
        var groupDetail = groupData
            .where((element) => element.groupId == data.groupId)
            .toList();
        var firstIndex =
            groupData.indexWhere((element) => element.groupId == data.groupId);
        var lastIndex = groupData
            .lastIndexWhere((element) => element.groupId == data.groupId);
        var newValueUpdate = <ListButtonPT3Model>[];
        for (var i = 0; i < groupDetail.length; i++) {
          newValueUpdate.add(groupDetail[i].copyWith(value: data.isChecked));
        }
        setState(() {
          groupData.replaceRange(firstIndex, lastIndex + 1, newValueUpdate);
        });
      }
      // getNumberOfChecked();
    }
  }

  String getNumberOfChecked() {
    numbersOfChecked = 0;
    area = '';
    groupData.forEach((element) {
      if (element.isChecked == true) {
        numbersOfChecked += 1;

        area += "," + element.areaName;
      }
    });
    return area;
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    getAreaAndAddGroupData();
  }

  getAreaAndAddGroupData() async {
    var areaValue = await UserSecureStorage.instance.getArea() ?? '';
    if (areaValue == "") {
      area = "WHOLE_COUNTRY".tr();
    } else {
      area = areaValue;
    }
    addGroupData();
    setState(() {});
  }

  addGroupData() {
    groupData = <ListButtonPT3Model>[
      ListButtonPT3Model(
        groupId: 0,
        groupName: 'WHOLE_COUNTRY'.tr(),
        areaId: 0,
        areaName: 'WHOLE_COUNTRY'.tr(),
        hasCheckBox: false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
        groupId: 1,
        groupName: '北海道',
        areaId: 1,
        areaName: '北海道',
        isChecked: area.indexOf("北海道") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
        groupId: 2,
        groupName: '東北',
        areaId: 2,
        areaName: '東北',
        isChecked: area.indexOf("東北") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
          groupId: 2,
          groupName: '東北',
          areaId: 3,
          areaName: '　青森県',
          isChecked: area.indexOf("青森県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 2,
          groupName: '東北',
          areaId: 4,
          areaName: '　秋田県',
          isChecked: area.indexOf("秋田県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 2,
          groupName: '東北',
          areaId: 5,
          areaName: '　岩手県',
          isChecked: area.indexOf("岩手県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 2,
          groupName: '東北',
          areaId: 7,
          areaName: '　山形県',
          isChecked: area.indexOf("山形県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 2,
          groupName: '東北',
          areaId: 8,
          areaName: '　宮城県',
          isChecked: area.indexOf("宮城県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 2,
          groupName: '東北',
          areaId: 9,
          areaName: '　福島県',
          isChecked: area.indexOf("福島県") != -1 ? true : false),
      ListButtonPT3Model(
        groupId: 3,
        groupName: '関東',
        areaId: 10,
        areaName: '関東',
        isChecked: area.indexOf("関東") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
          groupId: 3,
          groupName: '関東',
          areaId: 11,
          areaName: '　群馬県',
          isChecked: area.indexOf("群馬県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 3,
          groupName: '関東',
          areaId: 12,
          areaName: '　栃木県',
          isChecked: area.indexOf("栃木県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 3,
          groupName: '関東',
          areaId: 13,
          areaName: '　茨城県',
          isChecked: area.indexOf("茨城県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 3,
          groupName: '関東',
          areaId: 14,
          areaName: '　埼玉県',
          isChecked: area.indexOf("埼玉県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 3,
          groupName: '関東',
          areaId: 15,
          areaName: '　東京都',
          isChecked: area.indexOf("東京都") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 3,
          groupName: '関東',
          areaId: 16,
          areaName: '　千葉県',
          isChecked: area.indexOf("千葉県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 3,
          groupName: '関東',
          areaId: 17,
          areaName: '　神奈川県',
          isChecked: area.indexOf("神奈川県") != -1 ? true : false),
      ListButtonPT3Model(
        groupId: 4,
        groupName: '甲信越・北陸',
        areaId: 18,
        areaName: '甲信越・北陸',
        isChecked: area.indexOf("甲信越・北陸") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
          groupId: 4,
          groupName: '甲信越・北陸',
          areaId: 19,
          areaName: '　新潟県',
          isChecked: area.indexOf("新潟県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 4,
          groupName: '甲信越・北陸',
          areaId: 20,
          areaName: '　長野県',
          isChecked: area.indexOf("長野県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 4,
          groupName: '甲信越・北陸',
          areaId: 21,
          areaName: '　山梨県',
          isChecked: area.indexOf("山梨県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 4,
          groupName: '甲信越・北陸',
          areaId: 22,
          areaName: '　富山県',
          isChecked: area.indexOf("富山県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 4,
          groupName: '甲信越・北陸',
          areaId: 23,
          areaName: '　石川県',
          isChecked: area.indexOf("石川県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 4,
          groupName: '甲信越・北陸',
          areaId: 24,
          areaName: '　福井県',
          isChecked: area.indexOf("福井県") != -1 ? true : false),
      ListButtonPT3Model(
        groupId: 5,
        groupName: '東海',
        areaId: 25,
        areaName: '東海',
        isChecked: area.indexOf("東海") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
          groupId: 5,
          groupName: '東海',
          areaId: 26,
          areaName: '　静岡県',
          isChecked: area.indexOf("静岡県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 5,
          groupName: '東海',
          areaId: 27,
          areaName: '　岐阜県',
          isChecked: area.indexOf("岐阜県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 5,
          groupName: '東海',
          areaId: 28,
          areaName: '　愛知県',
          isChecked: area.indexOf("愛知県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 5,
          groupName: '東海',
          areaId: 29,
          areaName: '　三重県',
          isChecked: area.indexOf("三重県") != -1 ? true : false),
      ListButtonPT3Model(
        groupId: 6,
        groupName: '中国',
        areaId: 30,
        areaName: '中国',
        isChecked: area.indexOf("中国") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
          groupId: 6,
          groupName: '中国',
          areaId: 31,
          areaName: '　鳥取県',
          isChecked: area.indexOf("鳥取県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 6,
          groupName: '中国',
          areaId: 32,
          areaName: '　岡山県',
          isChecked: area.indexOf("岡山県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 6,
          groupName: '中国',
          areaId: 33,
          areaName: '　島根県',
          isChecked: area.indexOf("島根県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 6,
          groupName: '中国',
          areaId: 34,
          areaName: '　広島県',
          isChecked: area.indexOf("広島県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 6,
          groupName: '中国',
          areaId: 35,
          areaName: '　山口県',
          isChecked: area.indexOf("山口県") != -1 ? true : false),
      ListButtonPT3Model(
        groupId: 7,
        groupName: '四国',
        areaId: 36,
        areaName: '四国',
        isChecked: area.indexOf("四国") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
          groupId: 7,
          groupName: '四国',
          areaId: 37,
          areaName: '　愛媛県',
          isChecked: area.indexOf("愛媛県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 7,
          groupName: '四国',
          areaId: 38,
          areaName: '　香川県',
          isChecked: area.indexOf("香川県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 7,
          groupName: '四国',
          areaId: 39,
          areaName: '　高知県',
          isChecked: area.indexOf("高知県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 7,
          groupName: '四国',
          areaId: 40,
          areaName: '　徳島県',
          isChecked: area.indexOf("徳島県") != -1 ? true : false),
      ListButtonPT3Model(
        groupId: 8,
        groupName: '九州',
        areaId: 41,
        areaName: '九州',
        isChecked: area.indexOf("九州") != -1 ? true : false,
        isAreaCateory: true,
      ),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 42,
          areaName: '　長崎県',
          isChecked: area.indexOf("長崎県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 43,
          areaName: '　佐賀県',
          isChecked: area.indexOf("佐賀県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 44,
          areaName: '　福岡県',
          isChecked: area.indexOf("福岡県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 45,
          areaName: '　熊本県',
          isChecked: area.indexOf("熊本県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 46,
          areaName: '　大分県',
          isChecked: area.indexOf("大分県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 47,
          areaName: '　宮崎県',
          isChecked: area.indexOf("宮崎県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 48,
          areaName: '　鹿児島県',
          isChecked: area.indexOf("鹿児島県") != -1 ? true : false),
      ListButtonPT3Model(
          groupId: 8,
          groupName: '九州',
          areaId: 49,
          areaName: '　沖縄県',
          isChecked: area.indexOf("沖縄県") != -1 ? true : false),
    ];
    keys = <GlobalKey>[];
    // Max index is 8
    for (var i = 0; i < 9; i++) {
      keys.add(GlobalKey());
    }
  }
}

class ListButtonPT3Model {
  final int groupId;
  final String groupName;
  final int areaId;
  final String areaName;
  final bool isChecked;
  final bool hasCheckBox;
  final bool isAreaCateory;

  ListButtonPT3Model(
      {this.groupId = 0,
      this.groupName = '',
      this.areaId = 0,
      this.areaName = '',
      this.isChecked = false,
      this.hasCheckBox = true,
      this.isAreaCateory = false});

  ListButtonPT3Model copyWith(
      {int? groupId,
      String? groupName,
      int? areaId,
      String? areaName,
      bool? value,
      bool? isCheckBox,
      bool? isAreaCateory}) {
    return ListButtonPT3Model(
        groupId: groupId ?? this.groupId,
        groupName: groupName ?? this.groupName,
        areaId: areaId ?? this.areaId,
        areaName: areaName ?? this.areaName,
        isChecked: value ?? this.isChecked,
        hasCheckBox: isCheckBox ?? this.hasCheckBox,
        isAreaCateory: isAreaCateory ?? this.isAreaCateory);
  }
}
