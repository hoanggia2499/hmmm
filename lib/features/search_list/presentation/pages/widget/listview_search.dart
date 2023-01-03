import 'package:flutter/cupertino.dart';
import 'package:mirukuru/core/db/favorite_hive.dart';
import 'package:mirukuru/core/widgets/row_widget/listview_widget.dart';
import 'package:mirukuru/core/widgets/row_widget/template_pattern_1.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class ListviewSearch extends StatefulWidget {
  List<ItemSearchModel>? listItemSearchModel;
  final Function(int, List<int>) callBackItemChecked;
  ScrollController? scrollController;
  final Function(int)? topCallBack;
  final Function(bool, int)? favoriteCallBack;
  final VoidCallback? phoneCallBack;
  final Function(int)? quoteCallBack;
  final VoidCallback? deleteCallBack;
  final VoidCallback? completedLoadMore;
  final List<int> initListNumberOfChecked;
  final List<FavoriteHive> initListFavorite;
  final bool? isShowCheckBox;
  final bool isEndList;
  final LoadMorePage? loadMorePageCallback;
  final Future<void> Function()? onPullRefreshCallback;
  final int totalItemsCount;

  ListviewSearch({
    required this.listItemSearchModel,
    required this.callBackItemChecked,
    required this.topCallBack,
    required this.favoriteCallBack,
    required this.phoneCallBack,
    required this.quoteCallBack,
    required this.deleteCallBack,
    this.isShowCheckBox = true,
    required this.completedLoadMore,
    required this.initListNumberOfChecked,
    required this.initListFavorite,
    required this.scrollController,
    this.isEndList = false,
    this.loadMorePageCallback,
    this.totalItemsCount = 0,
    this.onPullRefreshCallback,
  });

  @override
  State<ListviewSearch> createState() => _ListviewSearchState();
}

class _ListviewSearchState extends State<ListviewSearch> {
  int currentNumberOfChecked = 0;

  @override
  void initState() {
    super.initState();
    getCurrentNumberOfChecked();
  }

  getCurrentNumberOfChecked() {
    for (int i = 0; i < widget.initListNumberOfChecked.length; i++) {
      currentNumberOfChecked += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListViewWidget(
      scrollController: widget.scrollController,
      isEndList: widget.isEndList,
      countTotalListData: (widget.listItemSearchModel?.length ?? 0) + 1,
      rowEventCallBack: (index) => _buildItemSearch(index),
      onPullRefreshCallback: widget.onPullRefreshCallback,
      loadMorePageCallback: widget.loadMorePageCallback,
    );
  }

  bool isCheck(int index) {
    for (int i = 0; i < widget.initListNumberOfChecked.length; i++) {
      if (widget.initListNumberOfChecked[i] == index) {
        return true;
      }
    }
    return false;
  }

  bool isFavorite(ItemSearchModel itemSearchModel) {
    var questionNo = itemSearchModel.corner + itemSearchModel.fullExhNum;
    for (int i = 0; i < widget.initListFavorite.length; i++) {
      if (widget.initListFavorite[i].questionNo == questionNo) {
        return true;
      }
    }
    return false;
  }

  _buildItemSearch(int index) {
    if (widget.listItemSearchModel != null &&
        widget.listItemSearchModel!.isNotEmpty &&
        index < (widget.listItemSearchModel!.length)) {
      var itemSearchModel = widget.listItemSearchModel?[index];

      if (itemSearchModel != null) {
        return TemplatePattern1(
            isFavorite: isFavorite(itemSearchModel),
            value: isCheck(index),
            itemTemPlate: itemSearchModel,
            isShowCheckBox: widget.isShowCheckBox,
            typeButton: 1,
            topCallBack: () {
              widget.topCallBack!.call(index);
            },
            checkBoxCallBack: (bool value) {
              if (value != null) {
                if (value) {
                  currentNumberOfChecked += 1;
                  widget.initListNumberOfChecked.add(index);
                } else {
                  currentNumberOfChecked -= 1;
                  widget.initListNumberOfChecked
                      .removeWhere((item) => item == index);
                }

                print(currentNumberOfChecked);
                print(widget.initListNumberOfChecked);
              }
              widget.callBackItemChecked(
                  currentNumberOfChecked, widget.initListNumberOfChecked);
            },
            favoriteCallBack: (bool isFavorite) {
              widget.favoriteCallBack!.call(isFavorite, index);
            },
            phoneCallBack: () {
              widget.phoneCallBack!.call();
            },
            quoteCallBack: () {
              widget.quoteCallBack!.call(index);
            },
            deleteCallBack: () {
              widget.deleteCallBack!.call();
            });
      }
    }
    return SizedBox();
  }
}
