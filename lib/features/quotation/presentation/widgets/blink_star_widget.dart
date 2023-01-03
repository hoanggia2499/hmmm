import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';

class BlinkStarWidget extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onClickedListener;

  const BlinkStarWidget(
      {Key? key, required this.initialValue, required this.onClickedListener})
      : super(key: key);

  @override
  _BlinkStarWidgetState createState() => _BlinkStarWidgetState();
}

class _BlinkStarWidgetState extends State<BlinkStarWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _touchAnimation;

  late AnimationController _tailAnimationController;
  late Animation<double> _tailAnimation;
  bool _isChecked = false;

  bool _isLongPress = false;

  void animate() {
    _animationController.forward();

    if (!_isChecked) {
      _tailAnimationController.forward();
    }

    setState(() {
      _isChecked = !_isChecked;
      widget.onClickedListener(_isChecked);
    });
  }

  void longPressAnimate(bool isStart) {
    if (isStart) {
      setState(() {
        _isLongPress = true;
      });
      _animationController.forward();
    } else {
      _animationController.reverse();

      if (!_isChecked) {
        _tailAnimationController.forward();
      }

      setState(() {
        _isChecked = !_isChecked;
        _isLongPress = false;
        widget.onClickedListener(_isChecked);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      _isChecked = widget.initialValue;
    });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _tailAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _touchAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeIn,
            reverseCurve: Curves.easeOut));

    _tailAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _tailAnimationController, curve: Curves.linear));

    _tailAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _tailAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _tailAnimationController.stop();
      }
    });

    _touchAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isLongPress) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed && !_isLongPress) {
        _animationController.stop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: Feedback.wrapForTap(animate, context),
        onLongPressStart: (details) => longPressAnimate(true),
        onLongPressEnd: (details) => longPressAnimate(false),
        onLongPress: Feedback.wrapForLongPress(() {}, context),
        child: Container(
          width: Dimens.getWidth(46.0),
          height: Dimens.getHeight(46.0),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.centerRight,
            children: [
              Positioned.fill(
                  top: 0.0,
                  left: Dimens.getWidth(10.0),
                  right: Dimens.getWidth(10.0),
                  child: FadeTransition(
                    opacity: _tailAnimation,
                    child: Image.asset(
                      "assets/images/png/star_tail.png",
                      width: Dimens.getWidth(46.0),
                      height: Dimens.getHeight(24.0),
                    ),
                  )),
              Positioned.fill(
                top: Dimens.getHeight(24.0),
                bottom: 0.0,
                child: ScaleTransition(
                  scale: _touchAnimation,
                  child: Image.asset(
                    "assets/images/png/star.png",
                    color: _isChecked
                        ? Colors.yellow
                        : ResourceColors.color_E1E1E1,
                    width: Dimens.getWidth(30.0),
                    height: Dimens.getHeight(30.0),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
