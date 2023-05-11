import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/material.dart';

import 'table_info_column_widget.dart';

///表信息行组件
class TableInfoRowWidget<T> extends StatelessWidget {
  const TableInfoRowWidget(
    this.controller, {
    Key? key,
    required this.columns,
    required this.rowHeight,
    this.infoAlignment,
  }) : super(key: key);

  final FlexibleTableController<T> controller;
  final Set<FlexibleColumn<T>> columns;
  final double rowHeight;

  ///列信息组件在容器内的对齐方式
  final AlignmentGeometry? infoAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns
          .map<Widget>(
            (currentColumn) => TableInfoColumnWidget<T>(
              controller,
              column: currentColumn,
              rowHeight: rowHeight,
              infoAlignment: infoAlignment,
            ),
          )
          .toList(growable: false),
    );
  }
}
