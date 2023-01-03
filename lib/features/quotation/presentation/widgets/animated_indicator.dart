import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';

const _kAnimateDuration = Duration(milliseconds: 300);

class AnimatedIndicator extends StatefulWidget {
  final String icon;
  final Duration animDuration;
  final AnimatedIndicatorState state;

  const AnimatedIndicator(
      {Key? key,
      required this.icon,
      this.animDuration = _kAnimateDuration,
      this.state = AnimatedIndicatorState.INITIAL})
      : super(key: key);

  @override
  _AnimatedIndicatorState createState() => _AnimatedIndicatorState();
}

class _AnimatedIndicatorState extends State<AnimatedIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  static const double TARGET_ANGLE = 180 / 360;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: widget.animDuration,
        lowerBound: 0.0,
        upperBound: TARGET_ANGLE);

    super.initState();
  }

  Widget _buildChild(BuildContext context, Widget? child) {
    return RotationTransition(
      turns: _animationController.view,
      child: Image.asset(widget.icon,
          width: Dimens.getWidth(12.0), height: Dimens.getHeight(12.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _updateState(),
      builder: _buildChild,
    );
  }

  _updateState() {
    widget.state == AnimatedIndicatorState.ON
        ? _animationController.reverse()
        : _animationController.forward();
    return _animationController.view;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum AnimatedIndicatorState { INITIAL, ON, OFF }
