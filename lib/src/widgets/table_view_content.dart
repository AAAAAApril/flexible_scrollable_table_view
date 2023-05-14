import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_info_row_widget.dart';

///表内容
class TableViewContent<T> extends StatelessWidget {
  const TableViewContent(
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
    //可动列信息区域
    final Widget scrollableColumnInfoArea = SingleChildScrollView(
      controller: controller.contentAreaScrollController,
      scrollDirection: Axis.horizontal,
      physics: physics,
      padding: EdgeInsets.zero,
      primary: false,
      child: TableInfoRowWidget<T>(
        controller,
        columnConfigurations: columnConfigurations,
        columns: columnConfigurations.scrollableColumns,
      ),
    );
    if (columnConfigurations.pinnedColumns.isEmpty) {
      return scrollableColumnInfoArea;
    }
    return Row(children: [
      //不动列信息区域
      TableInfoRowWidget<T>(
        controller,
        columnConfigurations: columnConfigurations,
        columns: columnConfigurations.pinnedColumns,
      ),
      Flexible(child: scrollableColumnInfoArea),
    ]);
  }
}
