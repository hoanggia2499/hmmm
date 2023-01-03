import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class TapOrHoldButton extends StatefulWidget {
  /// Update callback
  final VoidCallback onUpdate;

  /// Minimum delay between update events when holding the button
  final int minDelay;

  /// Initial delay between change events when holding the button
  final int initialDelay;

  /// Number of steps to go from [initialDelay] to [minDelay]
  final int delaySteps;

  final String labelText;

  const TapOrHoldButton(
      {Key? key,
      required this.onUpdate,
      this.minDelay = 80,
      this.initialDelay = 300,
      this.delaySteps = 5,
      this.labelText = "+"})
      : assert(minDelay <= initialDelay,
            "The minimum delay cannot be larger than the initial delay"),
        super(key: key);

  @override
  _TapOrHoldButtonState createState() => _TapOrHoldButtonState();
}

class _TapOrHoldButtonState extends State<TapOrHoldButton> {
  /// True if the button is currently being held
  bool _holding = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: setLinearGradient(Radius.circular(0.0),
            Radius.circular(0.0), Radius.circular(0.0), Radius.circular(0.0)),
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.width / 8,
        child: TextWidget(
          alignment: TextAlign.center,
          label: widget.labelText,
          textStyle: MKStyle.t32R.copyWith(color: ResourceColors.color_59),
        ),
      ),
      onTap: () => _stopHolding(),
      onTapDown: (_) => _startHolding(),
      onTapCancel: () => _stopHolding(),
    );
  }

  setLinearGradient(
      Radius topLeft, Radius topRight, Radius bottomLeft, Radius bottomRight) {
    return BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight),
        gradient: LinearGradient(
          colors: [
            Colors.black26,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ));
  }

  void _startHolding() async {
    // Make sure this isn't called more than once for
    // whatever reason.
    if (_holding) return;
    _holding = true;

    // Calculate the delay decrease per step
    final step =
        (widget.initialDelay - widget.minDelay).toDouble() / widget.delaySteps;
    var delay = widget.initialDelay.toDouble();

    while (_holding) {
      print("[tap_on] _holding");
      widget.onUpdate();
      await Future.delayed(Duration(milliseconds: delay.round()));
      if (delay > widget.minDelay) delay -= step;
    }
  }

  void _stopHolding() {
    _holding = false;
  }
}
