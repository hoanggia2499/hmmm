import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/core_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/listview_widget.dart';
import 'package:mirukuru/features/question/data/models/query_list_bean.dart';

class ListViewQuestionWidget extends StatefulWidget {
  List<QueryListBean> listData;
  bool isShowDeleteIcon;
  final Function(List<String>)? callBackItemChecked;
  Function(int) onItemClick;
  List<String> initItemChecked;
  final bool isEndList;
  final LoadMorePage? loadMorePageCallback;
  final int totalItemsCount;
  final Future<void> Function()? onPullRefreshCallback;

  ListViewQuestionWidget({
    required this.listData,
    this.isShowDeleteIcon = false,
    required this.initItemChecked,
    required this.onItemClick,
    this.callBackItemChecked,
    this.isEndList = false,
    this.loadMorePageCallback,
    this.totalItemsCount = 0,
    this.onPullRefreshCallback,
  });

  @override
  State<ListViewQuestionWidget> createState() => _ListViewQuestionWidgetState();
}

class _ListViewQuestionWidgetState extends State<ListViewQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListViewWidget(
      padding: EdgeInsets.only(left: Dimens.getWidth(0.0)),
      countTotalListData: widget.listData.length + 1,
      rowEventCallBack: (int index) => index < (widget.listData.length)
          ? RowWidgetPattern21(
              isShowCheckbox: widget.isShowDeleteIcon,
              contentTop: widget.listData[index].name,
              contentBottom: getUnit(widget.listData[index]),
              isCheck: isCheck(widget.listData[index].id +
                  ',' +
                  widget.listData[index].questionNum),
              onCheckChange: (value) => {
                if (value == true)
                  {
                    widget.initItemChecked.add(widget.listData[index].id +
                        ',' +
                        widget.listData[index].questionNum),
                  }
                else
                  {
                    widget.initItemChecked.removeWhere((element) =>
                        element ==
                        (widget.listData[index].id +
                            ',' +
                            widget.listData[index].questionNum)),
                  },
                setState(() {}),
                widget.callBackItemChecked!(widget.initItemChecked),
              },
              onItemClick: () => {widget.onItemClick.call(index)},
              icon: widget.listData[index].kindImage,
            )
          : SizedBox(height: Dimens.getHeight(100.0)),
      onPullRefreshCallback: widget.onPullRefreshCallback,
      loadMorePageCallback: widget.loadMorePageCallback,
      isEndList: widget.isEndList,
    );
  }

  String getUnit(QueryListBean queryListBean) {
    String inspection = queryListBean.unit;
    return DateFormat("yyyy/MM/dd HH:mm").format(DateTime.parse(inspection));
  }

  bool isCheck(String currentIndexValue) {
    bool check = false;
    widget.initItemChecked.forEach((element) {
      if (element == currentIndexValue) {
        check = true;
      }
    });
    return check;
  }
}
