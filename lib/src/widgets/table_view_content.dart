import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/material.dart';

import 'table_info_row_widget.dart';

///表内容
class TableViewContent<T> extends StatelessWidget {
  const TableViewContent(
    this.controller, {
    Key? key,
    required this.fixedColumns,
    required this.scrollableColumns,
    required this.infoRowHeight,
    this.infoAlignment,
  }) : super(key: key);

  final FlexibleTableController<T> controller;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<FlexibleColumn<T>> fixedColumns;

  ///可以左右滑动的列
  final Set<FlexibleColumn<T>> scrollableColumns;

  ///表信息行高度
  final double infoRowHeight;

  ///列信息组件在容器内的对齐方式
  final AlignmentGeometry? infoAlignment;

  @override
  Widget build(BuildContext context) {
    //可动列信息区域
    final Widget scrollableColumnInfoArea = SingleChildScrollView(
      controller: controller.dataAreaScrollController,
      scrollDirection: Axis.horizontal,
      child: TableInfoRowWidget<T>(
        controller,
        columns: scrollableColumns,
        rowHeight: infoRowHeight,
        infoAlignment: infoAlignment,
      ),
    );
    if (fixedColumns.isEmpty) {
      return scrollableColumnInfoArea;
    }
    return Row(
      children: [
        //不动列信息区域
        TableInfoRowWidget<T>(
          controller,
          columns: fixedColumns,
          rowHeight: infoRowHeight,
          infoAlignment: infoAlignment,
        ),
        Expanded(
          child: scrollableColumnInfoArea,
        ),
      ],
    );
  }
}
