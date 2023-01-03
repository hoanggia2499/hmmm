import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/config/common.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/listview_widget.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_button.dart';
import 'package:mirukuru/core/widgets/listview_widget/listview_title_pattern_2.dart';
import 'package:mirukuru/features/carlist/data/models/car_model.dart';
import 'package:mirukuru/features/login/data/models/login_model.dart';

class CarTypePickerDialog extends StatefulWidget {
  final CarModel? initCarModel;
  final List<CarModel> listCarModel;
  final LoginModel loginModel;
  final Function(String) onPopCallback;

  const CarTypePickerDialog(
      {Key? key,
      required this.listCarModel,
      required this.loginModel,
      required this.onPopCallback,
      this.initCarModel})
      : super(key: key);

  @override
  _CarTypePickerDialogState createState() => _CarTypePickerDialogState();
}

class _CarTypePickerDialogState extends State<CarTypePickerDialog> {
  late Map<String, List<CarModel>> groupData;
  late List<GlobalKey> groupKeys;
  late List<GlobalKey> keys;
  late ScrollController controller;

  List<CarModel> listCarModel = [];

  @override
  void initState() {
    super.initState();

    listCarModel = widget.listCarModel;
    groupKeys = <GlobalKey>[];
    groupData = {};
    controller = ScrollController();
    initListData();
    if (widget.initCarModel != null) {
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
        appBarTitle: "CAR_NAME".tr(),
        body: _buildBody());
  }

  _buildBody() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListViewWidget(
            expandLeft: 5,
            expandRight: 1,
            widgetList: ListViewTitlePattern2(
              initCarModel: widget.initCarModel,
              isFromCarRegist: true,
              listItemData: groupData,
              callBack: (value) {},
              keys: groupKeys,
              controller: controller,
              callBackItemChecked:
                  (int numOfItemChecked, List<String> itemChecked) {
                widget.onPopCallback.call(itemChecked.first);
              },
            ),
            widgetListButton: ListViewButtonPage(
              textAlign: TextAlign.center,
              listItemButton: groupData,
              callBack: (value) {
                changePosition(value);
              },
            )),
      );

  void changePosition(String key) {
    var index = groupData.keys.toList().indexOf(key);
    var renderObject = groupKeys[index].currentContext?.findRenderObject();
    if (renderObject != null) {
      controller.position
          .ensureVisible(renderObject, duration: Duration(milliseconds: 300));
    }
  }

  void changePositionToInitValue() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var initGroupSection = groupData.entries.firstWhere((element) {
        return element.value.contains(widget.initCarModel);
      });

      var initGroupSectionIndex = groupData.keys
          .toList()
          .indexWhere((key) => initGroupSection.key == key);
      var elementIndexInGroupSection =
          initGroupSection.value.indexOf(widget.initCarModel!);

      var offset = 0.0;
      if (initGroupSectionIndex == -1) {
        Logging.log.warn("index not found");
      } else {
        for (int i = 0; i < groupData.entries.length; i++) {
          var element = groupData.entries.elementAt(i);
          if (i < initGroupSectionIndex) {
            offset += (element.value.length * Dimens.getHeight(30.0)) +
                Dimens.getHeight(15.0);
          } else if (i == initGroupSectionIndex) {
            if (elementIndexInGroupSection > 0) {
              offset +=
                  ((elementIndexInGroupSection) * Dimens.getHeight(30.0)) +
                      Dimens.getHeight(15.0);
            }
          }
        }
      }

      controller.animateTo(offset,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  initListData() {
    MakerCodeValues.hiraganaAlphabetRegexList.entries.forEach((alphabetRegex) {
      var dataListByAlphabet = listCarModel
          .where((element) =>
              element.carGroup.startsWith(RegExp(alphabetRegex.value)))
          .toList();

      if (dataListByAlphabet.isNotEmpty) {
        groupData.addAll({alphabetRegex.key: dataListByAlphabet});
        groupKeys.add(GlobalKey());
      }
    });
  }
}
