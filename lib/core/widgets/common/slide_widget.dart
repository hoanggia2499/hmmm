import 'package:flutter/material.dart';

const _kSlideDuration = Duration(milliseconds: 300);

class HidableActionsWidget extends StatefulWidget {
  final Widget child;
  final Duration animDuration;
  final Offset slideOffset;
  final bool? isHiding;

  HidableActionsWidget(
      {super.key,
      required this.child,
      this.animDuration = _kSlideDuration,
      required this.slideOffset,
      this.isHiding = false});

  @override
  State<HidableActionsWidget> createState() => _HidableActionsWidgetState();
}

class _HidableActionsWidgetState extends State<HidableActionsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animDuration,
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.slideOffset,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn));
  }

  Animation<Offset> _animate(bool? isHiding) {
    if (isHiding == null) return _offsetAnimation;

    isHiding ? _controller.forward() : _controller.reverse();
    return _offsetAnimation;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animate(widget.isHiding),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
