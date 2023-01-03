import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

// Multi choice text button row
class RowWidgetPattern20 extends StatefulWidget {
  final String textStr;
  final String content;
  VoidCallback? rowCallBack;

  RowWidgetPattern20(
      {required this.textStr,
      required this.content,
      required this.rowCallBack});

  @override
  _RowWidgetPattern20State createState() => _RowWidgetPattern20State();
}

class _RowWidgetPattern20State extends State<RowWidgetPattern20> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  _buildMainRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.getHeight(10.0),
        bottom: Dimens.getHeight(10.0),
        right: Dimens.getHeight(10.0),
        left: Dimens.getHeight(10.0),
      ),
      child: Row(
        children: <Widget>[
          // Title
          Expanded(
            flex: 3,
            child: TextWidget(
              label: widget.textStr,
              textStyle: MKStyle.t12R.copyWith(color: ResourceColors.color_70),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(

                /// Shade setting, no longer needed in new design
                // decoration: BoxDecoration(
                //     color: ResourceColors.disabledTextColor,
                //     gradient: LinearGradient(
                //         begin: AlignmentDirectional.topCenter,
                //         end: AlignmentDirectional.bottomCenter,
                //         tileMode: TileMode.mirror,
                //         colors: createLinearColor()),
                //     boxShadow: [
                //       BoxShadow(color: Color(0xFFA2A2A2), offset: Offset(0, 1)),
                //       BoxShadow(color: Color(0xFFCDCDCD), offset: Offset(1, 0))
                //     ],
                //     borderRadius: BorderRadius.circular(2.0)),
                child: GestureDetector(
              onTap: () {
                widget.rowCallBack!.call();
              },
              child: TextWidget(
                alignment: TextAlign.end,
                label: widget.content,
                textStyle: MKStyle.t16R,
              ),
            )),
          ),
          SizedBox(
            width: Dimens.getWidth(33.0),
          )
        ],
      ),
    );
  }

  List<Color> createLinearColor() {
    return [
      Color(0xFFE2E2E2),
      Color(0xFFEBEBEB),
      Color(0xFFEAEAEA),
      Color(0xFFE9E9E9),
      Color(0xFFE5E5E5),
      Color(0xFFE4E4E4),
      Color(0xFFE3E3E3),
      Color(0xFFE2E2E2),
      Color(0xFFE1E1E1),
      Color(0xFFD9D9D9),
      Color(0xFFD8D8D8),
      Color(0xFFD7D7D7),
      Color(0xFFD6D6D6),
      Color(0xFFD5D5D5),
      Color(0xFFD4D4D4),
      Color(0xFFD3D3D3),
      Color(0xFFD2D2D2),
      Color(0xFFD1D1D1),
    ];
  }
}
