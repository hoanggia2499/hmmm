import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/text_widget.dart';

class CheckListButton extends StatefulWidget {
  const CheckListButton({required this.listData});

  final List<dynamic> listData; // { groupName, key, value }

  @override
  CheckListButtonState createState() => CheckListButtonState();
}

class CheckListButtonState extends State<CheckListButton> {
  late List<GlobalKey> listKey;
  late List<String> listMenuButton;
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    for (var item in widget.listData) {
      listKey.add(GlobalKey());
      listMenuButton.add(item['groupName']);
    }
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _buildAllListView(),
        ),
        Expanded(
          flex: 1,
          child: _buildMenuButton(),
        )
      ],
    );
  }

  Widget _buildAllListView() {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children:
            widget.listData.map((element) => _buildGroupList(element)).toList(),
      ),
    );
  }

  Widget _buildGroupList(List<dynamic> data) {
    var index = listMenuButton.indexOf(data[0]['groupName']);
    return Column(
      children: [
        Container(
          key: listKey[index],
          child: TextWidget(
            label: listMenuButton[index],
          ),
        )
      ],
    );
  }

  Widget _buildMenuButton() {
    return Container(
        decoration: BoxDecoration(color: Color(0xFF777777)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: listMenuButton
              .map((item) => TextButton(
                    onPressed: () => onPressMenu(item),
                    child: TextWidget(
                      label: item,
                    ),
                  ))
              .toList(),
        ));
  }

  void onPressMenu(String key) {
    var index = listMenuButton.indexOf(key);
    var renderBox =
        listKey[index].currentContext?.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);
    controller.animateTo(position.dy,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
