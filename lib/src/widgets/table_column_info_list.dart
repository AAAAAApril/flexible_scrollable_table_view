import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/material.dart';

///可左右滚动的列信息列
class TableColumnInfoList<T> extends StatelessWidget {
  const TableColumnInfoList(
    this.controller, {
    Key? key,
    required this.column,
    required this.rowHeight,
    this.infoAlignment,
  }) : super(key: key);

  final FlexibleTableController<T> controller;
  final FlexibleColumn<T> column;
  final double rowHeight;

  ///列信息组件在容器内的对齐方式
  final AlignmentGeometry? infoAlignment;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: value
            .map<Widget>(
              (data) => TableColumnInfoWidget(
                controller,
                data: data,
                column: column,
                height: rowHeight,
                infoAlignment: infoAlignment,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
