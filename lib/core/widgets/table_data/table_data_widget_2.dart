import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class TableDataWidgetPage02 extends StatefulWidget {
  @override
  _TableDataWidgetPage02State createState() => _TableDataWidgetPage02State();
}

class _TableDataWidgetPage02State extends State<TableDataWidgetPage02> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.getHeight(10.0), horizontal: Dimens.getWidth(10.0)),
      child: Column(
        children: [
          _buildItemRow(
            '店舗名',
            '８２４８モータース',
          ),
          _buildItemRow(
            '住所　',
            '〒440-0083\n東京都中央区晴海ー丁目８２４８',
          ),
          _buildItemRow(
            '電話番号',
            '8888008248',
          ),
          _buildItemRow(
            'Eメール',
            '88888248@localhost',
          ),
          _buildItemRow(
            '定休日',
            '',
          ),
          _buildItemRow(
            '営業時間',
            '',
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String labelLeft, String valueLeft) {
    return IntrinsicHeight(
        child: Container(
      margin: EdgeInsets.only(bottom: Dimens.getHeight(1.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildTextItem(labelLeft, ResourceColors.color_FF3C83EC,
                textColor: Colors.white),
          ),
          Expanded(
            flex: 3,
            child: _buildTextItem(valueLeft, ResourceColors.disabledBgColor),
          ),
        ],
      ),
    ));
  }

  Widget _buildTextItem(String label, Color bgColor,
      {Color textColor = Colors.black}) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.getHeight(5.0), horizontal: Dimens.getWidth(5.0)),
      decoration: BoxDecoration(color: bgColor),
      child: TextWidget(
        label: label,
        textStyle: MKStyle.t12R.copyWith(color: textColor),
      ),
    );
  }
}
