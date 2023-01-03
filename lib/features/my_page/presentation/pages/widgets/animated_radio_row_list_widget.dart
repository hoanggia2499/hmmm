import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/common/radio_widget.dart';
import 'package:mirukuru/features/my_page/presentation/pages/widgets/animated_radio_row_widget.dart';

class AnimatedRadioListRowWidget extends StatefulWidget {
  final List<String> inputValues;
  final Function(int) onValueChanged;
  final Function(int) onRowTappedCallback;
  final bool isHideRadioButton;
  int? defaultCheckedIndex;

  AnimatedRadioListRowWidget({
    Key? key,
    required this.inputValues,
    required this.onValueChanged,
    required this.onRowTappedCallback,
    required this.isHideRadioButton,
    int? defaultCheckedIndex,
  })  : this.defaultCheckedIndex =
            defaultCheckedIndex != null ? defaultCheckedIndex : 0,
        super(key: key);

  @override
  State<AnimatedRadioListRowWidget> createState() =>
      _AnimatedRadioListRowWidgetState();
}

class _AnimatedRadioListRowWidgetState
    extends State<AnimatedRadioListRowWidget> {
  late ScrollController _controller;
  int _currentCheckedIndex = 0;

  @override
  void initState() {
    _controller = ScrollController();
    _currentCheckedIndex = widget.defaultCheckedIndex!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width + Dimens.getWidth(100.0),
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: widget.inputValues
                .asMap()
                .entries
                .map((e) => _buildAnimatedRadioButton(e.key, e.value))
                .toList(),
          ),
        ));
  }

  Widget _buildAnimatedRadioButton(int currentRow, String input) {
    return AnimatedRadioRowWidget(
      context: context,
      currentRow: currentRow,
      currentChoice: _currentCheckedIndex,
      value: input,
      indicatorColor: ResourceColors.color_3768CE,
      spaceBetweenButtonAndLabel: Dimens.getWidth(15.0),
      thumbColor: ResourceColors.color_70,
      thumbWidth: 0.3,
      style: RadioWidgetStyle.STYLE_2,
      isRadioShow: widget.isHideRadioButton,
      onRadioTappedCallback: (position) {
        widget.onValueChanged(position);
        setState(() {
          _currentCheckedIndex = position;
        });
      },
      onRowTappedCallback: (position) => widget.onRowTappedCallback(position),
    );
  }
}
