import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/listview_widget/item_listview.dart';
import 'package:mirukuru/core/widgets/row_widget/row_widget_pattern_1.dart';
import 'package:mirukuru/features/body_list/data/models/body_model.dart';

class ListViewTitlePattern3 extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final Map<String, List<BodyModel>> listItemData;
  final Function(int) callBack;
  final List<GlobalKey> keys;
  final ScrollController controller;
  final Function(int, List<String>) callBackItemChecked;
  bool isFromCarRegist;

  ListViewTitlePattern3(
      {Key? key,
      this.padding = EdgeInsets.zero,
      required this.listItemData,
      required this.callBack,
      required this.callBackItemChecked,
      required this.keys,
      required this.controller,
      this.isFromCarRegist = false})
      : super(key: key);

  @override
  ListViewTitlePattern3State createState() => ListViewTitlePattern3State();
}

class ListViewTitlePattern3State extends State<ListViewTitlePattern3> {
  int currentNumberOfChecked = 0;
  List<String> itemChecked = [];

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 0.0,
      thumbVisibility: true,
      hoverThickness: 0.0,
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
    listWidget.add(SizedBox(height: Dimens.getHeight(50.0)));
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

  List<Widget> _buildGroupDetail(List<BodyModel> listData, int index) {
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
          widgetItems: _buildContent(
              index,
              item.carGroup,
              item.numOfCarASOne.toString(),
              listData.length - 1,
              detailIndex,
              '${item.makerCode}|${item.asnetCarCode}|${item.carGroup}|${item.makerName}')));
      detailIndex++;
    }
    return listWidget;
  }

  Widget _buildContent(int index, String itemName, String itemNumber,
      int totalItem, int detailIndex, String key) {
    return Column(children: [
      InkWell(
        onTap: () {
          widget.callBack.call(index);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: RowWidgetPattern1(
            isFromCarRegist: widget.isFromCarRegist,
            mainTitle: itemName,
            subTitle: '($itemNumber)',
            initValue: itemChecked.isNotEmpty && itemChecked.contains(key),
            onCheckChanged: (value) {
              if (value != null) {
                if (value) {
                  //   setState(() {
                  itemChecked.add(key);
                  print(key);
                  widget.callBackItemChecked
                      .call(itemChecked.length, itemChecked);
                  //   });
                } else {
                  //  setState(() {
                  itemChecked.removeWhere((element) => element == key);
                  widget.callBackItemChecked(itemChecked.length, itemChecked);
                  //   });
                }
              }
            },
            flexRightContent: 7,
            displayDivider: detailIndex != totalItem,
          ),
        ),
      ),
    ]);
  }
}
