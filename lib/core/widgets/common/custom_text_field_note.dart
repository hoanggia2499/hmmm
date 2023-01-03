import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';

class CustomTextFieldNote extends StatelessWidget {
  const CustomTextFieldNote({
    Key? key,
    required this.maxLines,
    required this.fieldNoteController,
    this.maxLength,
  }) : super(key: key);

  final int maxLines;
  final TextEditingController fieldNoteController;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines * Dimens.getHeight(20.0),
      child: TextField(
        controller: fieldNoteController,
        maxLines: maxLines,
        style: MKStyle.t14R,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: "",
          fillColor: ResourceColors.color_FFFFFF,
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: ResourceColors.color_929292, width: 1.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
                color: ResourceColors.color_000000, width: 1.0),
          ),
          filled: true,
        ),
      ),
    );
  }
}
