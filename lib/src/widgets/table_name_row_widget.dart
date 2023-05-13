import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_column_name_widget.dart';

///表的列名行
class TableNameRowWidget<T> extends StatelessWidget {
  const TableNameRowWidget(
    this.controller, {
    Key? key,
    required this.columns,
    required this.rowHeight,
  }) : super(key: key);

  final FlexibleTableController<T> controller;
  final Set<FlexibleColumn<T>> columns;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns
          .map<Widget>(
            (e) => TableColumnNameWidget<T>(
              controller,
              column: e,
              height: rowHeight,
            ),
          )
          .toList(growable: false),
    );
  }
}
