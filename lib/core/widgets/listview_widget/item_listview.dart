// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ItemListView extends StatefulWidget {
  final Widget widgetItems;

  final int index;

  final Function(int) onSelected;

  ItemListView({
    required this.widgetItems,
    required this.index,
    required this.onSelected,
  });

  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelected(widget.index);
      },
      child: widget.widgetItems,
    );
  }
}
