import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_name_row_widget.dart';

///表头部
class TableViewHeader<T> extends StatelessWidget {
  const TableViewHeader(
    this.controller, {
    Key? key,
    required this.pinnedColumns,
    required this.scrollableColumns,
    required this.headerHeight,
    this.nameAlignment,
    this.physics,
  }) : super(key: key);

  final FlexibleTableController<T> controller;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<FlexibleColumn<T>> pinnedColumns;

  ///可以左右滑动的列
  final Set<FlexibleColumn<T>> scrollableColumns;

  ///列名组件在容器内的对齐方式
  final AlignmentGeometry? nameAlignment;

  ///表头部高度
  final double headerHeight;

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
        columns: scrollableColumns,
        rowHeight: headerHeight,
        nameAlignment: nameAlignment,
      ),
    );
    if (pinnedColumns.isEmpty) {
      return scrollableNames;
    }
    return Row(
      children: [
        //不动列区域
        TableNameRowWidget<T>(
          controller,
          columns: pinnedColumns,
          rowHeight: headerHeight,
          nameAlignment: nameAlignment,
        ),
        Expanded(child: scrollableNames),
      ],
    );
  }
}
