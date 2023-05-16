import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/scroll_behavior.dart';
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

  //不动列信息区域
  Widget pinnedColumns() => TableInfoRowWidget<T>(
        controller,
        columnConfigurations: columnConfigurations,
        columns: columnConfigurations.pinnedColumns,
      );

  //可动列信息区域
  Widget scrollableColumnInfoArea() {
    Widget child = SingleChildScrollView(
      // controller: controller.contentAreaScrollController,
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
    if (controller.noHorizontalScrollBehavior) {
      child = ScrollConfiguration(
        behavior: NoOverscrollScrollBehavior(),
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    //两个都有
    if (columnConfigurations.pinnedColumns.isNotEmpty && columnConfigurations.scrollableColumns.isNotEmpty) {
      return Row(children: [
        pinnedColumns(),
        Flexible(child: scrollableColumnInfoArea()),
      ]);
    }
    //其中一个没有
    else {
      //不动的没有
      if (columnConfigurations.pinnedColumns.isEmpty) {
        return scrollableColumnInfoArea();
      }
      //只有不动的
      else {
        return pinnedColumns();
      }
    }
  }
}
