import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function(Size?) onSizeChanged;

  const WidgetSize({
    required Key key,
    required this.onSizeChanged,
    required this.child,
  }) : super(key: key);

  @override
  _WidgetSizeState createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  var widgetKey = GlobalKey();
  var oldSize;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onSizeChanged(newSize);
  }
}
