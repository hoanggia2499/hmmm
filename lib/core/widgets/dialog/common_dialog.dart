import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/common/custom_date_picker_japan_widget.dart';
import 'package:mirukuru/core/widgets/common/date_picker_widget.dart';
import 'package:mirukuru/core/widgets/common/date_picker_widget_2.dart';
import 'package:mirukuru/core/widgets/dialog/confirm_one_button_dialog.dart';
import 'package:mirukuru/core/widgets/common/custom_ios_date_picker_widget.dart';
import 'package:mirukuru/core/widgets/dialog/dialog_button_widget.dart';
import 'package:mirukuru/core/widgets/dialog/dialog_radio_button_widget.dart';
import 'package:mirukuru/core/widgets/dialog/photo_dialog_widget.dart';
import 'package:mirukuru/features/row_widget/presentation/pages/list_button_pattern_3.dart';
import 'package:mirukuru/features/search_input/data/models/input_model.dart';

import '../common/multi_column_picker.dart';
import 'dialog_menu_widget.dart';
import 'dialog_widget.dart';

class CommonDialog {
  static Future<bool> displayConfirmDialog(BuildContext context, Widget content,
      String okContent, String cancelContent,
      {VoidCallback? okEvent,
      VoidCallback? cancelEvent,
      bool isAutoDismiss = true}) async {
    var result = false;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            child: ConfirmDialog(
              content: content,
              okText: okContent,
              cancelText: cancelContent,
              eventOk: () {
                result = true;
                okEvent?.call();
              },
              eventCancel: cancelEvent,
              isAutoDismiss: isAutoDismiss,
            ),
            onWillPop: () async => false));

    return result;
  }

  static Future<bool> displayConfirmOneButtonDialog(BuildContext context,
      Widget content, String okContent, String cancelContent,
      {VoidCallback? okEvent,
      VoidCallback? cancelEvent,
      bool isAutoDismiss = true}) async {
    var result = false;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            child: ConfirmOneButtonDialog(
              content: content,
              okText: okContent,
              cancelText: cancelContent,
              eventOk: () {
                result = true;
                okEvent?.call();
              },
              eventCancel: cancelEvent,
              isAutoDismiss: isAutoDismiss,
            ),
            onWillPop: () async => false));

    return result;
  }

  static Future<bool> displayPhotoDialog(
    BuildContext context,
    Widget content,
    String okContent,
    String cancelContent, {
    VoidCallback? takePhotoEvent,
    VoidCallback? cancelEvent,
    VoidCallback? selectEvent,
  }) async {
    var result = false;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            child: PhotoDialog(
              content: content,
              okText: okContent,
              cancelText: cancelContent,
              eventTakeAPhoTo: () {
                result = true;
                takePhotoEvent?.call();
              },
              eventCancel: cancelEvent,
              eventSelectPhoto: selectEvent,
            ),
            onWillPop: () async => false));

    return result;
  }

  static Future<void> displayMenuDialog(BuildContext context) async {
    await showDialog(
        barrierColor: ResourceColors.color_trans,
        context: context,
        builder: (_) => DialogMenuWidget());
  }

  static Future<void> displayCupertinoDatePicker(
    BuildContext context,
    DateTime initialDateTime,
    ValueChanged<DateTime> onDateTimeChanged,
  ) async {
    await showDialog(
        barrierColor: ResourceColors.color_trans,
        context: context,
        builder: (_) {
          return CustomDatePicker(
            initialDateTime: initialDateTime,
            onDateTimeChanged: onDateTimeChanged,
            maximumYear: DateTime.now().year,
            minimumYear: 1,
          );
        });
  }

  static Future<void> displayCupertinoDatePickerJapan(
    BuildContext context,
    DateTime initialDateTime,
    ValueChanged<DateTime> onDateTimeChanged,
  ) async {
    await showDialog(
        barrierColor: ResourceColors.color_trans,
        context: context,
        builder: (_) {
          return CustomDatePickerJapan(
            initialDateTime: initialDateTime,
            onDateTimeChanged: onDateTimeChanged,
            maximumYear: DateTime.now().year + 5,
            minimumYear: DateTime.now().year,
          );
        });
  }

  static Future<void> displayDatePickerDialog(
      BuildContext context,
      List<String> firstValueList,
      List<String> secondValueList,
      int initFirstIndex,
      int initSecondIndex,
      Function(IndexModel)? onChange) async {
    await showDialog(
        barrierColor: ResourceColors.color_trans,
        context: context,
        builder: (_) => DatePickerWidget(
              openDatePicker: false,
              firstValueList: firstValueList,
              initFirstIndex: initFirstIndex,
              secondValueList: secondValueList,
              initSecondIndex: initSecondIndex,
              onChange: onChange,
            ));
  }

  static Future<void> displayDatePicker2Dialog(
      BuildContext context,
      List<String> firstValueList,
      int initFirstIndex,
      Function(IndexModel)? onChange) async {
    await showDialog(
        barrierColor: ResourceColors.color_trans,
        context: context,
        builder: (_) => DatePickerWidget2(
              openDatePicker: false,
              firstValueList: firstValueList,
              initFirstIndex: initFirstIndex,
              onChange: onChange,
            ));
  }

  static Future<void> displaySingleColumnPicker(BuildContext context,
      List<dynamic> data, int initIndex, ValueChanged<dynamic> onValueChanged,
      {bool useMagnifier = false}) async {
    await showDialog(
        barrierColor: ResourceColors.color_trans,
        context: context,
        builder: (_) {
          return MultiColumnPicker(
            valueArgs: [ColumnPickerData(initIndex: initIndex, data: data)],
            onValueChanged: (value) {
              dynamic selectedItem = value.getSelectedItemAtColumn(0);
              onValueChanged(selectedItem);
            },
            useMagnifier: useMagnifier,
          );
        });
  }

  static Future<void> displayMultiColumnPicker(
      BuildContext context,
      List<ColumnPickerData> valueArgs,
      ValueChanged<ColumnPickerSelectedItem> onValueChanged,
      {bool useMagnifier = false,
      bool needValidate = false}) async {
    await showDialog(
        barrierColor: ResourceColors.color_trans,
        context: context,
        builder: (_) {
          return MultiColumnPicker(
            valueArgs: valueArgs,
            needValidate:
                needValidate, //check Avoid getting values that don't match the search criteria
            onValueChanged: onValueChanged,
            useMagnifier: useMagnifier,
          );
        });
  }

  static Future<void> displayRadioButtonDialog(BuildContext context,
      List<String> listItem, int initValue, Function(int)? selectedItem) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            child: DialogRadioButtonWidget(
              initValue: initValue,
              listData: listItem,
              radioCallBack: (value) {
                selectedItem!.call(value);
              },
            ),
            onWillPop: () async => false));
  }

  static Future<void> displayAreaDialog(
      BuildContext context, Function(String)? callBack) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            child: ListButtonPattern3(
              callBackArea: callBack,
            ),
            onWillPop: () async => true));
  }

  static Future<void> displayFullScreenDialog(
      BuildContext context, Widget child) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (_) => WillPopScope(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: child,
              ),
            ),
            onWillPop: () async => false));
  }

  static Future<void> displayDialog(BuildContext context, String messageTitle,
      String messageContent, bool hasCallBack,
      {VoidCallback? eventCallBack,
      String buttonContent = 'OK',
      TextAlign textAlignContent = TextAlign.center}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
              onWillPop: () async => false,
              child: DialogWidget(
                title: messageTitle,
                content: messageContent,
                hasCallBack: hasCallBack,
                eventCallBack: eventCallBack,
                buttonContent: buttonContent,
                textAlignContent: textAlignContent,
              ),
            ));
  }
}
