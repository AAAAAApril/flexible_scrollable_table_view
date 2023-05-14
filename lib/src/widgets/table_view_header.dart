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

  @override
  Widget build(BuildContext context) {
    //可动列头区域
    final Widget scrollableColumns = SingleChildScrollView(
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
    if (columnConfigurations.pinnedColumns.isEmpty) {
      return scrollableColumns;
    }
    return Row(children: [
      //不动列区域
      TableHeaderRowWidget<T>(
        controller,
        columns: columnConfigurations.pinnedColumns,
        rowHeight: columnConfigurations.headerRowHeight,
      ),
      Flexible(child: scrollableColumns),
    ]);
  }
}
