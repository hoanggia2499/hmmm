import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/listview_widget.dart';
import 'package:mirukuru/features/search_list/data/models/search_list_model.dart';

class ListviewSearchHistoryWidget extends StatefulWidget {
  final Function(int)? onCallBackItemSearchHistory;
  final List<SearchListModel> listData;

  ListviewSearchHistoryWidget(
      {required this.onCallBackItemSearchHistory, required this.listData});

  @override
  State<ListviewSearchHistoryWidget> createState() =>
      _ListviewSearchHistoryWidgetState();
}

class _ListviewSearchHistoryWidgetState
    extends State<ListviewSearchHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return ListViewWidget(
        countTotalListData:
            (widget.listData.length > 30 ? 30 : widget.listData.length) + 1,
        rowEventCallBack: (int index) => index < (widget.listData.length)
            ? _buildMainRow(index)
            : SizedBox(height: Dimens.getHeight(100.0)));
  }

  Widget _buildMainRow(int index) {
    return InkWell(
        onTap: () => widget.onCallBackItemSearchHistory!.call(index),
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(
                left: Dimens.getHeight(5.0),
                right: Dimens.getHeight(5.0),
                top: Dimens.getHeight(5.0)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: Dimens.getHeight(10.0),
                      right: Dimens.getHeight(10.0)),
                  child: Row(
                    children: [
                      _buildRightSideWidget(index),
                      _buildNextbtn(),
                    ],
                  ),
                ),
                DividerNoText()
              ],
            ),
          ),
        ));
  }

  Widget _buildRightSideWidget(int index) {
    var item = widget.listData[index];
    return Container(
      width: MediaQuery.of(context).size.width - Dimens.getHeight(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            label:
                "${item.makerName.isNotEmpty ? item.makerName : ''}${item.carName1} ${item.carName2} ${item.carName3} ${item.carName4} ${item.carName5} ",
            textStyle: MKStyle.t14R,
          ),
          TextWidget(
            label: getInfoSearch(
                item.area,
                item.nenshiki1,
                item.nenshiki2,
                item.distance1,
                item.distance2,
                item.inspection,
                item.repair,
                item.price1,
                item.price2,
                item.haikiryou1,
                item.haikiryou2,
                item.mission,
                item.color,
                item.freeword),
            textStyle: MKStyle.t12R,
          )
        ],
      ),
    );
  }

  _buildNextbtn() {
    return Image.asset(
      "assets/images/png/next.png",
      width: Dimens.getHeight(10.0),
      height: Dimens.getHeight(10.0),
    );
  }

  String getArea(String area) {
    return area.isNotEmpty ? area : 'WHOLE_COUNTRY'.tr();
  }

  String getRegisterYear(String nenshiki1, String nenshiki2) {
    String year1 = nenshiki1.isNotEmpty
        ? HelperFunction.instance.getJapanYearFromAd(int.parse(nenshiki1))
        : '';
    String year2 = nenshiki2.isNotEmpty
        ? HelperFunction.instance.getJapanYearFromAd(int.parse(nenshiki2))
        : '';
    return (year1.isNotEmpty || year2.isNotEmpty)
        ? '${'MODEL_YEAR_HISTORY'.tr()}: $year1～$year2'
        : '';
  }

  String getDistance(String distance1, String distance2) {
    return (distance1.isNotEmpty || distance2.isNotEmpty)
        ? '${'DISTANCE'.tr()}: $distance1 ~ ${distance2}km'
        : '';
  }

  String getInspection(String inspection) {
    return inspection.isNotEmpty ? '${'CAR_INSPECTION'.tr()}: $inspection' : '';
  }

  String getRepair(String repair) {
    return repair.isNotEmpty ? '${'REPAIR_HISTORY'.tr()}: $repair' : '';
  }

  String getPrice(String price1, String price2) {
    if (price1.isEmpty) return "";
    if (price2.isEmpty) return "";
    var price1DoubleValue = int.parse(price1) / 10000;
    var price2DoubleValue = int.parse(price2) / 10000;
    price1 =
        "${Decimal.parse(price1DoubleValue.toString())}${'TEN_THOUSAND'.tr()}";
    price2 =
        "${Decimal.parse(price2DoubleValue.toString())}${'TEN_THOUSAND'.tr()}";
    return (price1.isNotEmpty || price2.isNotEmpty)
        ? '${'PRICE'.tr()}: $price1~$price2'
        : '';
  }

  String getHaikiryou(String haikiryou1, String haikiryou2) {
    return (haikiryou1.isNotEmpty || haikiryou2.isNotEmpty)
        ? '${'ENGINE_DISPLACEMENT'.tr()}：$haikiryou1~${haikiryou2}cc'
        : '';
  }

  String getMission(String mission) {
    return mission.isNotEmpty ? '${'HANDLE'.tr()}: $mission ' : '';
  }

  String getColor(String color) {
    return color.isNotEmpty ? '${'INTERIO_COLOR'.tr()}: $color' : '';
  }

  String getFreeword(String freeword) {
    return freeword.isNotEmpty ? '${'FREE_WORLD'.tr()}: $freeword' : '';
  }

  String getInfoSearch(
      String area,
      String nenshiki1,
      String nenshiki2,
      String distance1,
      String distance2,
      String inspection,
      String repair,
      String price1,
      String price2,
      String haikiryou1,
      String haikiryou2,
      String mission,
      String color,
      String freeword) {
    return '${getArea(area)}  ${getRegisterYear(nenshiki1, nenshiki2)}  ${getDistance(distance1, distance2)}  ${getInspection(inspection)}  ${getRepair(repair)}  ${getPrice(price1, price2)}  ${getHaikiryou(haikiryou1, haikiryou2)}  ${getMission(mission)}  ${getColor(color)}  ${getFreeword(freeword)}';
  }
}
