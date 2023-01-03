// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/constants.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class ListViewButtonPage extends StatefulWidget {
  Map<String, List> listItemButton;
  Function(String) callBack;
  TextAlign textAlign;
  int screenType;

  ListViewButtonPage(
      {required this.listItemButton,
      required this.callBack,
      this.textAlign = TextAlign.center,
      this.screenType = Constants.CAR_LIST_TYPE});

  @override
  _ListViewButtonPageState createState() => _ListViewButtonPageState();
}

class _ListViewButtonPageState extends State<ListViewButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: ResourceColors.color_FFFFFF),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildMenu(),
          ),
        ));
  }

  List<Widget> _buildMenu() {
    List<Widget> listWidget = [];
    for (var item in widget.listItemButton.entries) {
      listWidget.add(Container(
        margin: widget.screenType == Constants.CAR_LIST_TYPE
            ? EdgeInsets.only(bottom: Dimens.getHeight(10.0))
            : EdgeInsets.only(bottom: Dimens.getHeight(0.0)),
        width: double.maxFinite,
        child: InkWell(
          onTap: () async {
            await widget.callBack(item.key);
          },
          child: (widget.screenType == Constants.MAKER_LIST_TYPE ||
                  widget.screenType == Constants.BODY_LIST_TYPE)
              ? _buildItem(item)
              : _buildItemCarListType(item),
        ),
      ));
    }
    listWidget.add(SizedBox(
      height: Dimens.getHeight(65.0),
    ));
    return listWidget;
  }

  // Widget for Maker List Type and Body List Type
  _buildItem(var item) {
    return Container(
      decoration: BoxDecoration(
        color: ResourceColors.color_3768CE,
        border: Border(
            bottom: BorderSide(
          color: ResourceColors.color_FFFFFF,
          width: 1.0,
        )),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: Dimens.getHeight(25.0), top: Dimens.getHeight(25.0)),
        child: TextWidget(
          label: item.key,
          alignment: widget.textAlign,
          textStyle: MKStyle.t12B.copyWith(color: ResourceColors.color_EFEFEF),
        ),
      ),
    );
  }

  _buildItemCarListType(var item) {
    return Container(
      decoration: BoxDecoration(
        color: ResourceColors.color_3768CE,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimens.getHeight(8.0)),
        child: TextWidget(
          label: item.key == "POPULAR_CAR".tr() ? "POPULAR".tr() : item.key,
          alignment: widget.textAlign,
          textStyle: MKStyle.t14B.copyWith(color: ResourceColors.color_EFEFEF),
        ),
      ),
    );
  }
}
