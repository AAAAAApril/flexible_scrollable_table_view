import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_info_row_widget.dart';

///表内容
class TableViewContent<T> extends StatelessWidget {
  const TableViewContent(
    this.controller, {
    super.key,
    required this.columnController,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnController<T> columnController;

  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    //可动列信息区域
    final Widget scrollableColumnInfoArea = SingleChildScrollView(
      controller: controller.dataAreaScrollController,
      scrollDirection: Axis.horizontal,
      physics: physics,
      child: TableInfoRowWidget<T>(
        controller,
        columnController: columnController,
        columns: columnController.scrollableColumns,
      ),
    );
    if (columnController.pinnedColumns.isEmpty) {
      return scrollableColumnInfoArea;
    }
    return Row(
      children: [
        //不动列信息区域
        TableInfoRowWidget<T>(
          controller,
          columnController: columnController,
          columns: columnController.pinnedColumns,
        ),
        Expanded(child: scrollableColumnInfoArea),
      ],
    );
  }
}
