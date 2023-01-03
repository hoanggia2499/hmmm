import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/row_widget/common/tap_on.dart';
import 'package:mirukuru/core/widgets/row_widget/common/textfield_with_border.dart';

class ItemDateTime extends StatefulWidget {
  final Function(DateTime) callBackDateTime;

  ItemDateTime({required this.callBackDateTime});

  @override
  _ItemDateTimeState createState() => _ItemDateTimeState();
}

class _ItemDateTimeState extends State<ItemDateTime> {
  var now = new DateTime.now();
  var nowNext;
  int typeDATE = 1;
  int typeMONTH = 2;
  int typeYEAR = 3;

  @override
  void initState() {
    super.initState();
    nowNext = DateTime(now.year, now.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildColumnDateTime(
              typeMONTH, 3, monthsInYearShort[now.month], false,
              minusCallBack: () {
            changeMonth(now.month - 1);
          }, plusCallBack: () {
            changeMonth(now.month + 1);
          }, dateTime: (String dateTime) {
            int? month = monthsInYearNumber[dateTime];
            print(month);
            if (month != null) {
              now = DateTime(now.year, month, now.day);
            }
          }),
          SizedBox(
            width: Dimens.getWidth(10.0),
          ),
          _buildColumnDateTime(typeDATE, 2, now.day.toString(), true,
              minusCallBack: () {
            changeDate(now.day - 1);
          }, plusCallBack: () {
            changeDate(now.day + 1);
          }, dateTime: (String dateTime) {
            if (dateTime != '') {
              int day = int.parse(dateTime);
              print(day);
              now = DateTime(now.year, now.month, int.parse(dateTime));
            }
          }),
          SizedBox(
            width: Dimens.getWidth(10.0),
          ),
          _buildColumnDateTime(typeYEAR, 4, now.year.toString(), true,
              minusCallBack: () {
            changeYear(now.year - 1);
          }, plusCallBack: () {
            changeYear(now.year + 1);
          }, dateTime: (String dateTime) {
            if (int.tryParse(dateTime) != null) {
              int year = int.parse(dateTime);
              print(year);
              now = DateTime(year, now.month, now.day);
            }
          }),
        ],
      ),
    );
  }

  changeMonth(int value) {
    // Get numbers of date Next Month
    nowNext = DateTime(now.year, value + 1, 0);
    print(nowNext.day);

    // Get date Current of Month
    var nowCurrent = DateTime(now.year, value - 1, now.day);
    print(nowCurrent.day);

    if (nowNext.day < nowCurrent.day) {
      now = DateTime(now.year, value, nowNext.day);
    } else {
      now = DateTime(now.year, value, now.day);
    }
    setState(() {});
    widget.callBackDateTime.call(now);
  }

  changeDate(int value) {
    now = DateTime(now.year, now.month, value);

    setState(() {});
    widget.callBackDateTime.call(now);
  }

  changeYear(int value) {
    // Get numbers of date Next Month
    nowNext = DateTime(value, now.month + 1, 0);
    print(nowNext.day);
    // Get date Current Month
    var nowCurrent = DateTime(value, now.month - 1, now.day);
    print(nowCurrent.day);

    if (nowNext.day < nowCurrent.day) {
      now = DateTime(value, now.month, nowNext.day);
    } else {
      now = DateTime(value, now.month, now.day);
    }
    setState(() {});
    widget.callBackDateTime.call(now);
  }

  _buildColumnDateTime(
      int type, int maxLength, String? value, bool isKeyboardNumber,
      {VoidCallback? plusCallBack,
      VoidCallback? minusCallBack,
      Function(String)? dateTime}) {
    print("Max Date Of this Month: ");
    print(nowNext.day);

    value = extend0ToDate(type, value);

    return Container(
      decoration: setBoxDecoration(),
      child: Column(
        children: [
          TapOrHoldButton(
              onUpdate: () {
                plusCallBack!.call();
                // UnFocus TextField When Click +
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              labelText: "+"),
          Container(
            width: MediaQuery.of(context).size.width / 5,
            color: ResourceColors.color_94,
            height: 1,
          ),
          TextFieldWithBorder(
              typeDateTime: type,
              maxDateOfMonth: nowNext.day,
              isKeyboardNumber: isKeyboardNumber,
              maxlength: maxLength,
              hasColorFocus: true,
              hasEnabledBorder: false,
              textAlign: TextAlign.center,
              hasGradient: true,
              // contentPadding: EdgeInsets.all(Dimens.size35),
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.width / 8,
              initValue: value!,
              onSelectEvent: () {},
              onTextChange: (String value) {
                dateTime!.call(value);
                // widget.onTextChange?.call(value);
              }),
          Container(
            width: MediaQuery.of(context).size.width / 5,
            color: ResourceColors.color_94,
            height: 1,
          ),
          TapOrHoldButton(
              onUpdate: () {
                minusCallBack!.call();
                // Un Focus TextField When click -
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              labelText: "‒"),
        ],
      ),
    );
  }

  BoxDecoration setBoxDecoration() {
    return BoxDecoration(
      color: Colors.white, // set border width
      borderRadius:
          BorderRadius.all(Radius.circular(5.0)), // set rounded corner radius
    );
  }

  extend0ToDate(int type, String? value) {
    if (type == typeDATE) {
      int countValue = RegExp(r'\d').allMatches(value.toString()).length;
      String expand0 = "0";
      if (countValue == 1) {
        expand0 += value.toString();
        value = expand0;
      }
    }
    return value;
  }

  setLinearGradient(
      Radius topLeft, Radius topRight, Radius bottomLeft, Radius bottomRight) {
    return BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight),
        gradient: LinearGradient(
          colors: [
            Colors.black12,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ));
  }

  // Map<int, String> monthsInYear = {
  //   1: "January",
  //   2: "February",
  //   3: "March",
  //   4: "April",
  //   5: "May",
  //   6: "June",
  //   7: "July",
  //   8: "August",
  //   9: "September",
  //   10: "October",
  //   11: "November",
  //   12: "December"
  // };

  Map<int, String> monthsInYearShort = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };
  Map<String, int> monthsInYearNumber = {
    "Jan": 1,
    "Feb": 2,
    "Mar": 3,
    "Apr": 4,
    "May": 5,
    "June": 6,
    "Jul": 7,
    "Aug": 8,
    "Sep": 9,
    "Oct": 10,
    "Nov": 11,
    "Dec": 12,
  };
}
