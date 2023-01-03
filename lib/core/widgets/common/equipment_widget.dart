import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/resources/text_styles.dart';
import 'package:mirukuru/core/widgets/common/custom_check_box.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class EquipmentWidget extends StatefulWidget {
  const EquipmentWidget({Key? key}) : super(key: key);

  @override
  State<EquipmentWidget> createState() => _EquipmentWidgetState();
}

class _EquipmentWidgetState extends State<EquipmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            children: [
              _buildItem("PS", Dimens.getHeight(15.0)),
              _buildItem("PW", Dimens.getHeight(15.0)),
              _buildItem("TV", Dimens.getHeight(15.0)),
              _buildItem("ナビ", Dimens.getHeight(15.0)),
              _buildItem("靴シート", Dimens.getHeight(0.0)),
            ],
          ),
          Wrap(
            children: [
              _buildItem("SR", Dimens.getHeight(15.0)),
              _buildItem("AW", Dimens.getHeight(15.0)),
              _buildItem("エアバッグ", Dimens.getHeight(15.0)),
              _buildItem("ABS", Dimens.getHeight(0.0)),
            ],
          ),
          Wrap(
            children: [
              _buildItem("キーレス", Dimens.getHeight(15.0)),
              _buildItem("クルーズ", Dimens.getHeight(15.0)),
              _buildItem("取扱説明書", Dimens.getHeight(0.0)),
            ],
          ),
        ],
      ),
    );
  }

  _buildItem(String title, double alignRight) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.getHeight(10.0)),
      child: Wrap(
        children: [
          _buildCheckBox(0),
          TextWidget(
            alignment: TextAlign.center,
            textStyle:
                MKStyle.t16R.copyWith(color: ResourceColors.color_000000),
            label: title,
          ),
          SizedBox(
            width: Dimens.getHeight(alignRight),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBox(int index) {
    return CustomCheckbox(
      value: false,
      selectedIconColor: Colors.green,
      borderColor: Colors.grey,
      size: DimenFont.sp20,
      iconSize: DimenFont.sp20,
      // onChange: (value) => onCheckChange(value, index),
    );
  }
}
