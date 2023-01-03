import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/divider_no_text.dart';
import '../common/text_widget.dart';

class RowWidgetTextView extends StatefulWidget {
  final String title;
  final String? content;
  final VoidCallback? onTapped;
  final bool? isShowNextIcon;

  const RowWidgetTextView(
      {Key? key,
      required this.title,
      this.content,
      this.onTapped,
      bool? isShowNextIcon})
      : this.isShowNextIcon = isShowNextIcon ?? true,
        super(key: key);

  @override
  State<RowWidgetTextView> createState() => _RowWidgetTextViewState();
}

class _RowWidgetTextViewState extends State<RowWidgetTextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildMainRow(), DividerNoText()],
      ),
    );
  }

  Widget _buildMainRow() {
    return InkWell(
      onTap: widget.onTapped,
      child: Padding(
        padding: EdgeInsets.only(
            top: Dimens.getHeight(10.0),
            left: Dimens.getHeight(10.0),
            bottom: Dimens.getHeight(10.0),
            right: Dimens.getHeight(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitleWidget(),
            Flexible(
              fit: FlexFit.tight,
              child: _buildContentWidget(),
            )
          ],
        ),
      ),
    );
  }

  _buildTitleWidget() => TextWidget(
        label: widget.title,
        textStyle: MKStyle.t16R,
      );

  _buildContentWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: TextWidget(
            label: widget.content ?? "",
            textStyle: MKStyle.t14R,
            textOverflow: TextOverflow.visible,
            alignment: TextAlign.end,
          ),
        ),
        Visibility(
          visible: widget.isShowNextIcon ?? true,
          child: Padding(
            padding: EdgeInsets.only(left: Dimens.getWidth(25.0)),
            child: SvgPicture.asset(
              'assets/images/svg/next.svg',
              fit: BoxFit.fill, //Dimens.size15,
            ),
          ),
        ),
      ],
    );
  }
}
