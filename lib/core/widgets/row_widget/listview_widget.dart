import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/core_resource.dart';

typedef LoadMorePage = Function();

class ListViewWidget extends StatefulWidget {
  final int countTotalListData;
  final Function(int) rowEventCallBack;
  final EdgeInsetsGeometry padding;
  final Axis scrollDirection;
  final bool? isPrimary;
  final ScrollController? scrollController;
  final Future<void> Function()? onPullRefreshCallback;
  final bool isEndList;
  final LoadMorePage? loadMorePageCallback;

  ListViewWidget(
      {required this.countTotalListData,
      required this.rowEventCallBack,
      this.padding = EdgeInsets.zero,
      this.scrollDirection = Axis.vertical,
      this.isPrimary,
      this.scrollController,
      this.onPullRefreshCallback,
      this.isEndList = true,
      this.loadMorePageCallback});

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: widget.onPullRefreshCallback != null
          ? RefreshIndicator(
              onRefresh: widget.onPullRefreshCallback!,
              child: _buildListViewWidget(
                  isLoadMoreEnable: widget.loadMorePageCallback != null),
            )
          : _buildListViewWidget(
              isLoadMoreEnable: widget.loadMorePageCallback != null),
    );
  }

  Widget _buildChildListView({bool isLoadMoreEnable = false}) {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: widget.scrollDirection,
        controller: widget.scrollController,
        primary: widget.isPrimary,
        shrinkWrap: true,
        semanticChildCount: widget.countTotalListData,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: true,
        itemBuilder: (BuildContext context, int index) {
          return (isLoadMoreEnable &&
                  !widget.isEndList &&
                  (index == widget.countTotalListData - 1) &&
                  (index != 0))
              ? LoadMoreWidget()
              : widget.rowEventCallBack(index);
        },
        itemCount: widget.countTotalListData);
  }

  Widget _buildListViewWidget({bool isLoadMoreEnable = false}) {
    return NotificationListener<ScrollNotification>(
      child: ScrollConfiguration(
        behavior: CupertinoScrollBehavior(),
        child: _buildChildListView(isLoadMoreEnable: isLoadMoreEnable),
      ),
      onNotification: (notification) {
        // scroll to end of list
        if (isLoadMoreEnable &&
            !widget.isEndList &&
            notification is ScrollEndNotification &&
            (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent)) {
          widget.loadMorePageCallback!.call();
          return true;
        }
        return false;
      },
    );
  }
}

class LoadMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.getHeight(20.0), horizontal: Dimens.getHeight(20.0)),
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: ResourceColors.color_0e67ed,
      ),
    );
  }
}
