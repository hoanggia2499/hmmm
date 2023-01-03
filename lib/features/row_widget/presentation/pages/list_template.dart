import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';

class ListTemplate extends StatefulWidget {
  const ListTemplate({Key? key}) : super(key: key);

  @override
  _ListTemplateState createState() => _ListTemplateState();
}

class _ListTemplateState extends State<ListTemplate> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarTitle: 'List Template',
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(children: []),
        ),
      ),
    );
  }
}
