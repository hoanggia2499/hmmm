import 'package:flutter/material.dart';
import 'package:mirukuru/core/widgets/common/template_page.dart';
import 'package:mirukuru/core/widgets/table_data/table_data_widget_2.dart';

class TableDataWidgetPage extends StatefulWidget {
  @override
  _TableDataWidgetPageState createState() => _TableDataWidgetPageState();
}

class _TableDataWidgetPageState extends State<TableDataWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      appBarTitle: '共通Widget',
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Table Data 01
            //  TableDataWidgetPage01(),
            // Table Data 02
            TableDataWidgetPage02(),
          ],
        ),
      ),
    );
  }
}
