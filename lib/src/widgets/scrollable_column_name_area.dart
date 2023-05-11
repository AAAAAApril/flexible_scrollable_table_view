import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/material.dart';

import 'table_column_name_widget.dart';

///可左右滚动列名区域
class ScrollableColumnNameArea<T> extends StatelessWidget {
  const ScrollableColumnNameArea(
    this.controller, {
    Key? key,
    required this.columns,
    required this.rowHeight,
    this.nameAlignment,
  }) : super(key: key);

  final FlexibleTableController<T> controller;
  final Set<FlexibleColumn<T>> columns;
  final double rowHeight;

  ///列名组件在容器内的对齐方式
  final AlignmentGeometry? nameAlignment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.nameRowScrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: columns
            .map<Widget>(
              (e) => TableColumnNameWidget<T>(
                controller,
                column: e,
                height: rowHeight,
                nameAlignment: nameAlignment,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
