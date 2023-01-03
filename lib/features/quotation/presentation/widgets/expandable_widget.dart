import 'package:flutter/material.dart';

const _kExpandDuration = Duration(milliseconds: 300);
typedef ExpandableWidgetBuilder = Widget Function(
    BuildContext context, ExpandableWidgetState newState);

class ExpandableWidget extends StatefulWidget {
  final ExpandableWidgetBuilder headerWithIndicator;
  final Widget body;
  final Duration animDuration;
  final double collapsedVisibilityExtent;

  const ExpandableWidget({
    Key? key,
    required this.headerWithIndicator,
    required this.body,
    this.animDuration = _kExpandDuration,
    this.collapsedVisibilityExtent = 0.0,
  })  : assert(collapsedVisibilityExtent >= 0 && collapsedVisibilityExtent <= 1,
            "The param collapsedVisibilityExtent must between 0 and 1"),
        super(key: key);

  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animationFactor;
  ExpandableWidgetState _currentState = ExpandableWidgetState.INITIAL;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: widget.animDuration);

    _animationFactor = _animationController
        .drive(Tween(begin: widget.collapsedVisibilityExtent, end: 1.0));
  }

  Widget _buildWidgetContent(BuildContext context, Widget? child) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: InkWell(
            onTap: () {
              var currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              _onIndicatorTapped();
            },
            child: widget.headerWithIndicator(context, _currentState),
          ),
        ),
        SizeTransition(
          sizeFactor: _animationFactor,
          child: widget.body,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController.view, builder: _buildWidgetContent);
  }

  void _onIndicatorTapped() {
    setState(() {
      if (_currentState == ExpandableWidgetState.INITIAL ||
          _currentState == ExpandableWidgetState.COLLAPSED) {
        _currentState = ExpandableWidgetState.EXPANDED;
        _animationController.forward();
      } else {
        _currentState = ExpandableWidgetState.COLLAPSED;
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum ExpandableWidgetState { INITIAL, COLLAPSED, EXPANDED }
