import 'dart:async';

import 'package:flutter/material.dart';

class SlideAnimation extends StatefulWidget {
  const SlideAnimation(
      {Key? key,
      required this.child,
      required this.startOffset,
      required this.endOffset})
      : super(key: key);

  final Widget child;
  final Offset startOffset;
  final Offset endOffset;

  @override
  SlideState createState() => SlideState();
}

class SlideState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    Timer(Duration(milliseconds: 100), () => _controller.forward());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position:
            Tween<Offset>(begin: widget.startOffset, end: widget.endOffset)
                .animate(_controller),
        child: FadeTransition(
          opacity: _controller,
          child: widget.child,
        ));
  }
}
