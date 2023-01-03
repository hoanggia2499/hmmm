import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

const double _kItemExtent = 32.0;
const double _kMagnification = 2.35 / 2.1;
const double _kSqueeze = 1.25;

const Widget _startSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capEndEdge: false);
const Widget _centerSelectionOverlay = CupertinoPickerDefaultSelectionOverlay(
    capStartEdge: false, capEndEdge: false);
const Widget _endSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capStartEdge: false);
const Widget _fullEdgeSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay();

typedef _ColumnBuilder = Widget Function(
    double offAxisFraction,
    TransitionBuilder itemPositioningBuilder,
    Widget selectionOverlay,
    int index);

/// A multi-column picker widget in iOS Style
///
/// You can enter multiple column with a wide variety of data types
///
/// Multi-column Picker can be displayed directly on a screen or in a popup
///
/// [Example Use]
///
///```
///await showCupertinoModalPopup(
///             barrierColor: ResourceColors.color_trans,
///             context: context,
///             builder: (_) {
///               return MultiColumnPicker(
///                 valueArgs: [
///                   ColumnPickerData(initIndex: 0, data: familyStructureValues, flex: 1),
///                   ColumnPickerData(initIndex: 1, data: genderValues, flex: 1),
///                   ColumnPickerData(initIndex: 2, data: occupationalClassificationValues, flex: 6),
///                 ColumnPickerData(initIndex: 2, data: [3, "Phan Thị Minh Châu", 5614848854.0, CustomData("Chau", 333)], flex: 2),
///                 ],
///                 onValueChanged: (value) { Logging.log.info(value);},
///             );
///            });
/// ```
///
class MultiColumnPicker extends StatefulWidget {
  /// [valueArgs] is the initial data of the picker
  final List<ColumnPickerData> valueArgs;

  /// [onValueChanged] is the callback called when the selected item at any column changes and must not be null.
  final ValueChanged<ColumnPickerSelectedItem> onValueChanged;

  /// set [useMagnifier] = true if you want to zoom selected item, its default value = false
  final bool useMagnifier;

  ///Avoid getting values that don't match the search criteria
  bool needValidate;

  /// Constructs an Multi-column Picker
  ///
  /// [valueArgs] is the initial data of the picker
  ///
  /// [onValueChanged] is the callback called when the selected item at any column changes and must not be null.
  ///
  /// set [useMagnifier] = true if you want to zoom selected item, its default value = false
  MultiColumnPicker(
      {Key? key,
      required this.valueArgs,
      required this.onValueChanged,
      this.needValidate = false,
      this.useMagnifier = false})
      : super(key: key);

  @override
  State<MultiColumnPicker> createState() => _MultiColumnPickerState();
}

class _MultiColumnPickerState extends State<MultiColumnPicker> {
  List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
  List<FixedExtentScrollController> columnControllers = [];
  List<bool> isColumnAtPositionScrolling = [];

  bool get isScrolling => isColumnAtPositionScrolling.any((element) => element);

  late int pickColumnFlex;

  late ColumnPickerSelectedItem selectedColumnPickers;

  double magnification = 1.0;

  @override
  void initState() {
    for (int i = 0; i < widget.valueArgs.length; i++) {
      final initialItem = widget.valueArgs[i].initIndex;
      columnControllers
          .add(FixedExtentScrollController(initialItem: initialItem ?? 0));
    }

    isColumnAtPositionScrolling =
        List.generate(widget.valueArgs.length, (index) => false);

    pickColumnFlex = 10 ~/ widget.valueArgs.length;

    selectedColumnPickers = ColumnPickerSelectedItem.create(
        List.generate(widget.valueArgs.length, (index) {
      final valuesAtColumn = widget.valueArgs[index];
      return valuesAtColumn.data[valuesAtColumn.initIndex ?? 0];
    }));

    magnification = widget.useMagnifier ? _kMagnification : 1.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pickerBuilders = <_ColumnBuilder>[];

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: MediaQuery.of(context).size.height / 3,
              color: ResourceColors.color_FFFFFF,
              child: Stack(
                children: [
                  _buildMainItem(),
                  _buildTopItem(),
                  _buildBottomItem()
                ],
              )),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    columnControllers.forEach((controller) => controller.dispose());
  }

  Widget _buildPicker(
      double offAxisFraction,
      TransitionBuilder itemPositioningBuilder,
      Widget selectionOverlay,
      int index) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isColumnAtPositionScrolling[index] = true;
        } else if (notification is ScrollEndNotification) {
          isColumnAtPositionScrolling[index] = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: columnControllers[index],
        offAxisFraction: offAxisFraction,
        itemExtent: Dimens.getHeight(_kItemExtent),
        useMagnifier: widget.useMagnifier,
        magnification: magnification,
        backgroundColor: ResourceColors.color_FFFFFF,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int itemIndex) {
          final selectedItem = widget.valueArgs[index].data[itemIndex];
          selectedColumnPickers.updateSelectedItem(index, selectedItem);
        },
        looping: false,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(widget.valueArgs[index].data.length,
            (int widgetIndex) {
          return itemPositioningBuilder(
            context,
            _buildPickerLabel(
                widget.valueArgs[index].data[widgetIndex].toString()),
          );
        }),
      ),
    );
  }

  Widget _buildPickerLabel(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: FittedBox(
          fit: BoxFit.fill,
          child: TextWidget(
            label: text,
            textStyle: MKStyle.t14R.copyWith(color: ResourceColors.text_black),
            textOverflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }

  Widget _buildMainItem() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildPickerColumns(),
      ),
    );
  }

  List<Widget> _buildPickerColumns() {
    return List<Widget>.generate(widget.valueArgs.length, (index) {
      double offAxisFraction = 0.0;

      Widget selectionOverlay = _centerSelectionOverlay;
      if (widget.valueArgs.length > 1) {
        if (index == 0)
          selectionOverlay = _startSelectionOverlay;
        else if (index == widget.valueArgs.length - 1)
          selectionOverlay = _endSelectionOverlay;
      } else {
        selectionOverlay = _fullEdgeSelectionOverlay;
      }

      return Expanded(
        flex: widget.valueArgs[index].flex,
        child: _buildPicker(offAxisFraction, (context, child) {
          return child!;
        }, selectionOverlay, index),
      );
    });
  }

  /*  void _animateColumnControllerToItem(
      FixedExtentScrollController controller, int targetItem) {
    controller.animateToItem(targetItem,
        duration: const Duration(milliseconds: 2000), curve: Curves.easeInOut);
  }
 */
  Widget _buildBottomItem() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 18,
        child: Container(
          decoration: _buildBoxDecorationBottom(),
        ),
      ),
    );
  }

  Widget _buildTopItem() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 16,
            color: ResourceColors.color_E1E1E1,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: TextWidget(
                      label: "CANCEL".tr(),
                      textStyle: MKStyle.t14B
                          .copyWith(color: ResourceColors.color_3768CE),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.onValueChanged(selectedColumnPickers);
                      widget.needValidate
                          ? Logging.log.info('Validate column picker')
                          : Navigator.pop(context);
                    },
                    child: TextWidget(
                      label: "CONFIRM".tr(),
                      textStyle: MKStyle.t14B
                          .copyWith(color: ResourceColors.color_3768CE),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 18,
            child: Container(
              decoration: _buildBoxDecorationTop(),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecorationBottom() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ResourceColors.color_white_4,
          ResourceColors.color_FFFFFF,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  BoxDecoration _buildBoxDecorationTop() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ResourceColors.color_FFFFFF,
          ResourceColors.color_white_4,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  void _pickerDidStopScrolling() {
    setState(() {});

    if (isScrolling) {
      return;
    }
  }
}

class ColumnPickerData {
  final int? initIndex;
  final List<dynamic> data;
  final int flex;

  ColumnPickerData({
    int? initIndex,
    required this.data,
    this.flex = 5,
  }) : this.initIndex = (initIndex != null && initIndex >= 0) ? initIndex : 0;
}

class ColumnPickerSelectedItem {
  @protected
  final List<dynamic> _selectedItems;

  ColumnPickerSelectedItem.create(this._selectedItems);

  List<dynamic> get selectedItems => _selectedItems;

  set setSelectedItem(List<dynamic> value) {
    _selectedItems.clear();
    _selectedItems.addAll(value);
  }

  void updateSelectedItem(int columnIndex, dynamic value) {
    _selectedItems[columnIndex] = value;
  }

  dynamic getSelectedItemAtColumn(int index) {
    return _selectedItems[index];
  }

  @override
  String toString() {
    return 'ColumnPickerSelectedItem{_selectedItems: $_selectedItems}';
  }
}
