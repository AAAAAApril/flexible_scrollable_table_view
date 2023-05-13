import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_name_row_widget.dart';

///表头部
class TableViewHeader<T> extends StatelessWidget {
  const TableViewHeader(
    this.controller, {
    Key? key,
    required this.columnController,
    this.physics,
  }) : super(key: key);

  final FlexibleTableController<T> controller;
  final FlexibleColumnController<T> columnController;

  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    //可动列名区域
    final Widget scrollableNames = SingleChildScrollView(
      controller: controller.nameRowScrollController,
      scrollDirection: Axis.horizontal,
      physics: physics,
      child: TableNameRowWidget<T>(
        controller,
        columns: columnController.scrollableColumns,
        rowHeight: columnController.headerRowHeight,
      ),
    );
    if (columnController.pinnedColumns.isEmpty) {
      return scrollableNames;
    }
    return Row(
      children: [
        //不动列区域
        TableNameRowWidget<T>(
          controller,
          columns: columnController.pinnedColumns,
          rowHeight: columnController.headerRowHeight,
        ),
        Expanded(child: scrollableNames),
      ],
    );
  }
}
