import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/util/constants.dart';

class ListViewWithLoadMore extends StatefulWidget {
  @override
  _ListViewWithLoadMoreState createState() => _ListViewWithLoadMoreState();
  ScrollController? scrollController;
  int coutListDataLoaded;
  Function(int) rowEventCallBack;
  Function() pullRefreshCallBack;
  VoidCallback? completedLoadMore;

  ListViewWithLoadMore(
      {required this.scrollController,
      required this.coutListDataLoaded,
      required this.rowEventCallBack,
      required this.completedLoadMore,
      required this.pullRefreshCallBack});
}

class _ListViewWithLoadMoreState extends State<ListViewWithLoadMore> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.only(top: Dimens.getHeight(0)),
        itemBuilder: (BuildContext context, int index) {
          // Load UI Load More
          return updateDataRow(index, context, widget.coutListDataLoaded);
        },
        //+1: Using for Row Load More UI
        itemCount: widget.coutListDataLoaded + 1);
  }

  Widget completed() {
    return Container(
      height: Dimens.getHeight(55),
      child: Center(
          // child: Text('COMPLETE_LOAD_MORE'.tr(),
          //     style: new TextStyle(
          //       fontSize: DimenFont.sp17,
          //       fontFamily: "NotoSansJPMedium",
          //     )),
          ),
    );
  }

  Widget showLoadMoreUI() {
    /*  Widget body;
    body = CupertinoActivityIndicator(); */
    return Container(
        // height: Dimens.getHeight(55),
        // child: body,
        );
  }

  Widget updateDataRow(
      int index, BuildContext context, int? countListDataLoaded) {
    // LOAD MORE UI
    if (index == widget.coutListDataLoaded) {
      int remainData = widget.coutListDataLoaded % 10;
      if (remainData == Constants.REMAND_DATA) {
        return showLoadMoreUI();
      } else {
        widget.completedLoadMore!.call();
        return completed();
      }
    } else {
      return dataRow(index);
    }
  }

  // Reload API
  Future<void> _pullRefresh() async {
    widget.pullRefreshCallBack();
  }

  Widget dataRow(int index) {
    return widget.rowEventCallBack(index);
  }
}
