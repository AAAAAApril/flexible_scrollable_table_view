import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/material.dart';

import 'fixed_column_name_area.dart';
import 'scrollable_column_name_area.dart';

///表头部
class TableViewHeader<T> extends StatelessWidget {
  const TableViewHeader(
    this.controller, {
    Key? key,
    required this.fixedColumns,
    required this.scrollableColumns,
    this.nameAlignment,
    required this.headerHeight,
  }) : super(key: key);

  final FlexibleTableController<T> controller;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<FlexibleColumn<T>> fixedColumns;

  ///可以左右滑动的列
  final Set<FlexibleColumn<T>> scrollableColumns;

  ///列名组件在容器内的对齐方式
  final AlignmentGeometry? nameAlignment;

  ///表头部高度
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    //可动列名区域
    final Widget scrollableNames = ScrollableColumnNameArea<T>(
      controller,
      columns: scrollableColumns,
      rowHeight: headerHeight,
      nameAlignment: nameAlignment,
    );
    if (fixedColumns.isEmpty) {
      return scrollableNames;
    }
    return Row(
      children: [
        //不动列区域
        FixedColumnNameArea<T>(
          controller,
          columns: fixedColumns,
          rowHeight: headerHeight,
          nameAlignment: nameAlignment,
        ),
        Expanded(child: scrollableNames),
      ],
    );
  }
}
