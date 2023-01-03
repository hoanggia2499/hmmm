import 'package:flutter/material.dart';

class DefaultTabControllerListener extends StatefulWidget {
  const DefaultTabControllerListener(
      {Key? key, this.onTabSelected, required this.child})
      : super(key: key);

  final void Function(int index)? onTabSelected;
  final Widget child;

  @override
  _DefaultTabControllerListenerState createState() =>
      _DefaultTabControllerListenerState();
}

class _DefaultTabControllerListenerState
    extends State<DefaultTabControllerListener> {
  late final void Function()? _listener;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tabController = DefaultTabController.of(context)!;
      _listener = () {
        final onTabSelected = widget.onTabSelected;
        if (onTabSelected != null) {
          onTabSelected(tabController.index);
        }
      };
      tabController.addListener(_listener!);
    });
  }

  @override
  void didChangeDependencies() {
    _tabController = DefaultTabController.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_listener != null && _tabController != null) {
      _tabController!.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
