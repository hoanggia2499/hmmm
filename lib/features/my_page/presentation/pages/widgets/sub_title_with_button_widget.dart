import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class SubTitleWithButton extends StatefulWidget {
  final String label;
  SubtitleButton? actionButton;
  SubtitleStype labelStyle;

  SubTitleWithButton(
      {Key? key,
      required this.label,
      this.actionButton,
      SubtitleStype? labelStyle})
      : this.labelStyle = SubtitleStype(
            textStyle: MKStyle.t12R.copyWith(
                color: ResourceColors.color_757575,
                fontWeight: FontWeight.w500)),
        super(key: key);

  @override
  State<SubTitleWithButton> createState() => _SubTitleWithButtonState();
}

class _SubTitleWithButtonState extends State<SubTitleWithButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: ResourceColors.color_E1E1E1,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimens.getHeight(8.0), horizontal: Dimens.getWidth(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: Dimens.getWidth(10.0)),
              child: TextWidget(
                label: widget.label,
                textStyle: widget.labelStyle.textStyle ??
                    MKStyle.t12R.copyWith(fontWeight: FontWeight.w500),
                alignment: widget.labelStyle.alignment,
              ),
            ),
            _buildAddButton(widget.actionButton),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(SubtitleButton? subtitleButton) {
    return Visibility(
      visible: subtitleButton != null,
      child: GestureDetector(
        onTap: () => subtitleButton?.onTapCallback.call(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              subtitleButton!.image,
              width: Dimens.getWidth(15.0),
              height: Dimens.getHeight(15.0),
            ),
            TextWidget(
              label: subtitleButton.label,
              textStyle: MKStyle.t6R.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ResourceColors.color_757575),
            )
          ],
        ),
      ),
    );
  }
}

class SubtitleButton {
  String image;
  String label;
  Function onTapCallback;

  SubtitleButton(
      {required this.image, this.label = "", required this.onTapCallback});
}

class SubtitleStype {
  // Color textColor;
  //FontWeight fontWeight;
  double spaceBetweenCharacter;
  // double? fontSize;
  //String textFontFamily;
  TextAlign alignment;
  //TextDecoration textDecoration;
  TextStyle? textStyle;
  SubtitleStype(
      {
      // this.textColor = Colors.black,
      //  this.textDecoration = TextDecoration.none,
      this.spaceBetweenCharacter = 0,
      // this.fontWeight = FontWeight.w500,
      this.alignment = TextAlign.start,
      this.textStyle
      //this.textFontFamily = 'NotoSansJPRegular',
      // double? fontSize,
      });
  // this.fontSize = DimenFont.sp12;
}
