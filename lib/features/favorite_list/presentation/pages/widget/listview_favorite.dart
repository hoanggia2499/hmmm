import 'package:flutter/material.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/widgets/row_widget/template_pattern_1.dart';
import 'package:mirukuru/features/search_list/data/models/item_search_model.dart';

class ListViewFavorite extends StatefulWidget {
  List<ItemSearchModel>? favoriteObjectList;
  final Function(int)? topCallBack;
  final Function(int)? favoriteOrRemoveCallBack;
  final VoidCallback? phoneCallBack;
  final Function(int)? quoteCallBack;
  final VoidCallback? deleteCallBack;

  ListViewFavorite({
    required this.favoriteObjectList,
    required this.topCallBack,
    required this.favoriteOrRemoveCallBack,
    required this.phoneCallBack,
    required this.quoteCallBack,
    required this.deleteCallBack,
  });

  @override
  State<ListViewFavorite> createState() => _ListViewFavoriteState();
}

class _ListViewFavoriteState extends State<ListViewFavorite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.only(top: Dimens.getHeight(0)),
          itemBuilder: (BuildContext context, int index) {
            // Load UI Load More
            return _buildItemSearch(index);
          },
          itemCount: widget.favoriteObjectList!.length),
    );
  }

  _buildItemSearch(int index) {
    return TemplatePattern1(
        isFavorite: true,
        value: true,
        itemTemPlate: widget.favoriteObjectList![index],
        isShowCheckBox: false,
        typeButton: 1,
        topCallBack: () {
          widget.topCallBack!.call(index);
        },
        checkBoxCallBack: (bool value) {},
        favoriteCallBack: (bool isFavorite) {
          widget.favoriteOrRemoveCallBack!.call(index);
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
