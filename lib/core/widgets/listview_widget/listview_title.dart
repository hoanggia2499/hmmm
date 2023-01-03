// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/maker/data/models/item_maker_model.dart';

import 'item_listview.dart';

class ListViewTitlePage extends StatefulWidget {
  EdgeInsetsGeometry padding;
  Map<String, List<ItemMakerModel>> listItemData;
  Function(ItemMakerModel) callBack;
  List<GlobalKey> keys;
  ScrollController controller;
  bool isShowNumberOfItems;
  ItemMakerModel? initItem;
  Color? selectedColor;

  ListViewTitlePage(
      {this.padding = EdgeInsets.zero,
      required this.listItemData,
      required this.callBack,
      required this.keys,
      required this.controller,
      this.isShowNumberOfItems = true,
      this.selectedColor,
      this.initItem});

  @override
  _ListViewTitlePageState createState() => _ListViewTitlePageState();
}

class _ListViewTitlePageState extends State<ListViewTitlePage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 0.0,
      thumbVisibility: true,
      controller: widget.controller,
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildGroupListView(),
        ),
      ),
    );
  }

  List<Widget> _buildGroupListView() {
    List<Widget> listWidget = [];
    for (var item in widget.listItemData.entries) {
      var index = widget.listItemData.keys.toList().indexOf(item.key);
      listWidget.add(_buildGroupHeader(item.key, index));
      listWidget.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildGroupDetail(item.value, index),
      ));
    }
    return listWidget;
  }

  Widget _buildGroupHeader(String title, int index) {
    return Container(
        decoration: BoxDecoration(
          color: ResourceColors.color_dfdfdf,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            key: widget.keys[index],
            margin: EdgeInsets.only(
                left: Dimens.getWidth(15.0),
                top: Dimens.getWidth(5.0),
                bottom: Dimens.getWidth(5.0)),
            child: TextWidget(
              label: title,
              textStyle:
                  MKStyle.t12R.copyWith(color: ResourceColors.color_757575),
            ),
          ),
        ));
  }

  List<Widget> _buildGroupDetail(List<ItemMakerModel> listData, int index) {
    List<Widget> listWidget = [];
    var detailIndex = 0;
    for (var item in listData) {
      listWidget.add(ItemListView(
          index: index,
          onSelected: (value) async {
            setState(() {
              // widget.selectedIndex = value;
              print('Selected Item $value');
            });
          },
          widgetItems: _buildContent(item, listData.length - 1, detailIndex)));
      detailIndex++;
    }
    return listWidget;
  }

  Widget _buildContent(ItemMakerModel item, int totalItem, int detailIndex) {
    return Column(children: [
      InkWell(
        onTap: () {
          widget.callBack.call(item);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
              color: widget.initItem == item ? widget.selectedColor : null,
              padding: EdgeInsets.only(
                  left: Dimens.getWidth(10.0),
                  top: Dimens.getWidth(10.0),
                  bottom: Dimens.getWidth(10.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    label: item.makerName,
                    textStyle: MKStyle.t12R,
                  ),
                  item.numOfCarASOne != 0 && widget.isShowNumberOfItems
                      ? TextWidget(
                          label: '(${item.numOfCarASOne})',
                          textStyle:
                              MKStyle.t12R.copyWith(color: ResourceColors.grey))
                      // Dummy
                      : Container()
                ],
              )),
        ),
      ),
      Visibility(
          visible: detailIndex != totalItem,
          child: Container(
            height: Dimens.getSize(0.5),
            color: Colors.grey,
          ))
    ]);
  }
}
