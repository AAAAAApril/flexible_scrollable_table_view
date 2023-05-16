import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_header_row_widget.dart';

///表头部
class TableViewHeader<T> extends StatelessWidget {
  const TableViewHeader(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;
  final ScrollPhysics? physics;

  //不动列区域
  Widget pinnedColumns() => TableHeaderRowWidget<T>(
        controller,
        columns: columnConfigurations.pinnedColumns,
        rowHeight: columnConfigurations.headerRowHeight,
      );

  //可动列头区域
  Widget scrollableColumns() => SingleChildScrollView(
        controller: controller.headerRowScrollController,
        scrollDirection: Axis.horizontal,
        physics: physics,
        padding: EdgeInsets.zero,
        primary: false,
        child: TableHeaderRowWidget<T>(
          controller,
          columns: columnConfigurations.scrollableColumns,
          rowHeight: columnConfigurations.headerRowHeight,
        ),
      );

  @override
  Widget build(BuildContext context) {
    //两个都有
    if (columnConfigurations.pinnedColumns.isNotEmpty && columnConfigurations.scrollableColumns.isNotEmpty) {
      return Row(children: [
        pinnedColumns(),
        Flexible(child: scrollableColumns()),
      ]);
    }
    //其中一个有
    else {
      //不动的没有
      if (columnConfigurations.pinnedColumns.isEmpty) {
        return scrollableColumns();
      }
      //只有不动的
      else {
        return pinnedColumns();
      }
    }
  }
}
