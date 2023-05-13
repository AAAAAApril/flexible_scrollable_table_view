import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_column_header_widget.dart';

///表的列头行
class TableHeaderRowWidget<T> extends StatelessWidget {
  const TableHeaderRowWidget(
    this.controller, {
    super.key,
    required this.columns,
    required this.rowHeight,
  });

  final FlexibleTableController<T> controller;
  final Set<FlexibleColumn<T>> columns;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns
          .map<Widget>(
            (e) => TableColumnHeaderWidget<T>(
              controller,
              column: e,
              height: rowHeight,
            ),
          )
          .toList(growable: false),
    );
  }
}
