import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/widgets/common/listview_widget.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_button.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_title.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';

class MakerCodePickerDialog extends StatefulWidget {
  final List<ItemMakerModel> makerList;
  final LoginModel loginModel;
  final Function(ItemMakerModel) onPopCallback;
  final ItemMakerModel? initMaker;

  const MakerCodePickerDialog(
      {super.key,
      required this.makerList,
      required this.onPopCallback,
      required this.loginModel,
      this.initMaker});

  @override
  _MakerCodePickerDialogState createState() => _MakerCodePickerDialogState();
}

class _MakerCodePickerDialogState extends State<MakerCodePickerDialog> {
  late Map<String, List<ItemMakerModel>> groupData;
  late List<GlobalKey> keys;
  late ScrollController controller;

  List<ItemMakerModel> makerList = [];
  String groupName = 'JAPAN'.tr();

  @override
  void initState() {
    super.initState();

    makerList = widget.makerList;
    keys = <GlobalKey>[];
    groupData = {};
    controller = ScrollController();

    initGroupData();

    if (widget.initMaker != null) {
      changePositionToInitValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
        storeName: widget.loginModel.storeName2.isNotEmpty
            ? '${widget.loginModel.storeName}\n${widget.loginModel.storeName2}'
            : widget.loginModel.storeName,
        currentIndex: Constants.FAVORITE_INDEX,
        appBarLogo: widget.loginModel.logoMark.isEmpty
            ? ''
            : '${Common.imageUrl + widget.loginModel.memberNum + '/' + widget.loginModel.logoMark}',
        appBarColor: ResourceColors.color_FF1979FF,
        resizeToAvoidBottomInset: false,
        appBarTitle: "MAKER_NAME".tr(),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Container(
        color: ResourceColors.color_FFFFFF,
        child: ListViewWidget(
            expandLeft: 7,
            expandRight: 2,
            widgetList: ListViewTitlePage(
              listItemData: groupData,
              callBack: (item) {
                widget.onPopCallback(item);
              },
              keys: keys,
              controller: controller,
              isShowNumberOfItems: false,
              selectedColor: CupertinoColors.lightBackgroundGray,
              initItem: widget.initMaker,
            ),
            widgetListButton: ListViewButtonPage(
              screenType: Constants.MAKER_LIST_TYPE,
              listItemButton: groupData,
              callBack: (value) {
                changePosition(value);
              },
            )));
  }

  void changePosition(String key) {
    var index = groupData.keys.toList().indexOf(key);
    var renderObject = keys[index].currentContext?.findRenderObject();
    if (renderObject != null) {
      controller.position
          .ensureVisible(renderObject, duration: Duration(milliseconds: 300));
    }
  }

  void initGroupData() {
    List<ItemMakerModel> listData = [];
    for (var i = 0; i < makerList.length; i++) {
      if (makerList[i].numOfCarASOne == 99999 ||
          makerList[i].makerName == '----------') {
        groupData.addAll({groupName: listData});

        var replaceName = makerList[i].makerName.replaceAll('-', '');
        replaceName = replaceName.replaceAll('(', '');
        replaceName = replaceName.replaceAll(')', '');
        groupName = replaceName;
        if (groupName.isEmpty) {
          groupName = 'OTHERS'.tr();
        }
        listData = [];
        keys.add(GlobalKey());
      } else {
        listData.add(makerList[i]);
      }
    }
    if (makerList[makerList.length - 1].numOfCarASOne != 99999) {
      groupData.addAll({groupName: listData});
      keys.add(GlobalKey());
    }
  }

  void changePositionToInitValue() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var initGroupSection = groupData.entries.firstWhere((element) {
        return element.value.contains(widget.initMaker);
      });

      var initGroupSectionIndex = groupData.keys
          .toList()
          .indexWhere((key) => initGroupSection.key == key);
      var elementIndexInGroupSection =
          initGroupSection.value.indexOf(widget.initMaker!);

      var offset = 0.0;
      if (initGroupSectionIndex == -1) {
        Logging.log.warn("index not found");
      } else {
        for (int i = 0; i < groupData.entries.length; i++) {
          var element = groupData.entries.elementAt(i);
          if (i < initGroupSectionIndex) {
            offset += (element.value.length * Dimens.getHeight(30.0)) +
                Dimens.getHeight(25.0);
          } else if (i == initGroupSectionIndex) {
            if (elementIndexInGroupSection > 0) {
              offset +=
                  ((elementIndexInGroupSection) * Dimens.getHeight(30.0)) +
                      Dimens.getHeight(25.0);
            }
          }
        }
      }

      controller.animateTo(offset,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }
}
