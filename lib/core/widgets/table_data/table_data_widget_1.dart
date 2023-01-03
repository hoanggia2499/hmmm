import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/helper_function.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';
import 'package:mirukuru/features/search_detail/data/models/search_car_model.dart';

class TableDataWidgetPage01 extends StatefulWidget {
  ItemSearchModel itemSearchModel;
  SearchCarModel searchCarModel;
  bool hasEquipment;

  TableDataWidgetPage01(
      {required this.itemSearchModel,
      required this.searchCarModel,
      this.hasEquipment = true});
  @override
  _TableDataWidgetPage01State createState() => _TableDataWidgetPage01State();
}

class _TableDataWidgetPage01State extends State<TableDataWidgetPage01> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _buildItemRowTitle(
                labelLeft: "SITUATION".tr(),
                labelRight: "BASIC_SPECIFICATIONS".tr()),
            _buildItemRow(
              labelLeft: 'MODEL_YEAR_HISTORY'.tr(),
              valueLeft: HelperFunction.instance
                  .getJapanYearFromAd(widget.itemSearchModel.carModel),
              labelRight: 'ENGINE_DISPLACEMENT'.tr(),
              valueRight: widget.itemSearchModel.carVolume.toString() + "cc",
            ),
            _buildItemRow(
              labelLeft: 'MILEAGE'.tr(),
              valueLeft:
                  '${widget.itemSearchModel.carMileage / 10}${'TEN_THOUSAND'.tr()}km',
              labelRight: 'MISSTION'.tr(),
              valueRight: widget.itemSearchModel.shiftName,
            ),
            _buildItemRow(
              labelLeft: 'CAR_INSPECTION'.tr(),
              valueLeft: getInspection(widget.itemSearchModel.inspection),
              labelRight: 'DOOR'.tr(),
              valueRight: getCarDoors(),
            ),
            _buildItemRow(
                labelLeft: 'REPAIR_HISTORY'.tr(),
                valueLeft: widget.itemSearchModel.dTPointTotal == 'R'
                    ? "CAN_BE".tr()
                    : "NONE".tr(),
                labelRight: 'HANDLE'.tr(),
                valueRight: getHanbleName()),
            _buildItemRow(
              labelLeft: 'CAR_HISTORY'.tr(),
              valueLeft: getHistoryName(),
              labelRight: 'FUEL'.tr(),
              valueRight: widget.itemSearchModel.fuelName,
            ),
            _buildItemRow(
              labelLeft: 'LOCATION'.tr(),
              valueLeft: widget.itemSearchModel.carLocation,
              labelRight: 'AIR_CONDITION'.tr(),
              valueRight: getACName(),
            ),
            _buildItemRow(
              labelLeft: 'LAST_3_DIGITS_OF_CHASSIS_NUMBER'.tr(),
              valueLeft: getPlatFormNum(),
              labelRight: 'INTERIO_COLOR'.tr(),
              valueRight: widget.itemSearchModel.sysColorName,
            ),
            SizedBox(
              height: Dimens.getWidth(10),
            ),
            Visibility(
                visible: widget.hasEquipment,
                child: _buildItemRowTitle(
                    labelLeft: 'EQUIPMENT'.tr(), isTwoFieldInRow: false)),
            Visibility(
                visible: widget.hasEquipment, child: _buildItemEquiment()),
            Visibility(
              visible: widget.hasEquipment,
              child: SizedBox(
                height: Dimens.getWidth(40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildItemEquiment() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: ResourceColors.color_FFFFFF,
          border: Border.all(color: ResourceColors.color_E1E1E1, width: 1)),
      child: Padding(
        padding: EdgeInsets.only(bottom: Dimens.getWidth(30)),
        child: TextWidget(
          label: getEquipment(),
          textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_000000),
        ),
      ),
    );
  }

  String getCarForm() {
    String carForm = widget.searchCarModel.carForm;
    int hyfLoc = carForm.indexOf('-');
    return carForm = carForm.substring(hyfLoc + 1);
  }

  String getPlatFormNum() {
    int _len = widget.searchCarModel.platformNum.length;
    if (_len > 3) {
      String _right =
          widget.searchCarModel.platformNum.substring(_len - 3, _len);
      return _right;
    } else {
      return '';
    }
  }

  String getACName() {
    return widget.searchCarModel.acName;
  }

  String getHistoryName() {
    return widget.searchCarModel.historyName;
  }

  String getCarDoors() {
    if (widget.searchCarModel.carDoors != 0) {
      return widget.searchCarModel.carDoors.toString();
    } else {
      return '';
    }
  }

  String getHanbleName() {
    return widget.searchCarModel.handleName;
  }

  String getEquipment() {
    return widget.searchCarModel.equipment;
  }

  Widget _buildItemRow(
      {String labelLeft = '',
      String valueLeft = '',
      String labelRight = '',
      String valueRight = '',
      bool isTwoFieldInRow = true}) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(bottom: Dimens.getHeight(1.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildTextItem(labelLeft, ResourceColors.color_E1E1E1,
                  textColor: ResourceColors.color_70),
            ),
            Expanded(
              flex: isTwoFieldInRow ? 1 : 3,
              child: _buildTextItem(valueLeft, ResourceColors.color_FFFFFF,
                  textColor: ResourceColors.color_000000),
            ),
            SizedBox(
              width: Dimens.getWidth(10),
            ),
            Visibility(
              visible: isTwoFieldInRow,
              child: Expanded(
                child: _buildTextItem(labelRight, ResourceColors.color_E1E1E1,
                    textColor: ResourceColors.color_70),
              ),
            ),
            Visibility(
              visible: isTwoFieldInRow,
              child: Expanded(
                flex: isTwoFieldInRow ? 1 : 3,
                child: _buildTextItem(valueRight, ResourceColors.color_FFFFFF,
                    textColor: ResourceColors.color_000000),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRowTitle(
      {String labelLeft = '',
      String labelRight = '',
      bool isTwoFieldInRow = true}) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.only(bottom: Dimens.getHeight(1.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Row(
              children: [
                Image.asset(
                  "assets/images/png/dot.png",
                  width: DimenFont.sp10,
                  height: DimenFont.sp10,
                ),
                SizedBox(
                  width: Dimens.getWidth(10),
                ),
                TextWidget(label: labelLeft)
              ],
            )),
            Expanded(flex: 1, child: Container()),
            SizedBox(
              width: Dimens.getWidth(10),
            ),
            Visibility(
              visible: isTwoFieldInRow == false ? false : true,
              child: Expanded(
                  child: Row(
                children: [
                  Image.asset(
                    "assets/images/png/dot.png",
                    width: DimenFont.sp10,
                    height: DimenFont.sp10,
                  ),
                  SizedBox(
                    width: Dimens.getWidth(10),
                  ),
                  TextWidget(label: labelRight)
                ],
              )),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }

  String getInspection(String year) {
    String newYear = year.replaceAll(' ', '');
    if (newYear != '') {
      return HelperFunction.instance.getJapanYearFormat(newYear);
    } else {
      return '';
    }
  }

  Widget _buildTextItem(String label, Color bgColor,
      {Color textColor = Colors.black}) {
    return Container(
      padding: EdgeInsets.only(left: Dimens.getWidth(3.0)),
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: ResourceColors.color_E1E1E1, width: 1)),
      child: TextWidget(
        label: label,
        textStyle: MKStyle.t12R.copyWith(color: textColor),
      ),
    );
  }
}
