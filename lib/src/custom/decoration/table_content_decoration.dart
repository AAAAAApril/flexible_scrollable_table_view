import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

import 'table_row_decoration.dart';

///表内容区域装饰
class TableContentDecoration<T> extends StatelessWidget {
  const TableContentDecoration(
    this.controller, {
    super.key,
    required this.columnController,
    required this.columns,
    required this.decorationBuilder,
  });

  ///控制器
  final FlexibleTableController<T> controller;

  ///列配置
  final FlexibleColumnController<T> columnController;

  ///列配置
  final Set<FlexibleColumn<T>> columns;

  ///表信息装饰
  final TableInfoDecorationBuilder<T> decorationBuilder;

  Widget createRow(BuildContext context, T data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns.map<Widget>((column) => createDecoration(context, column, data)).toList(growable: false),
    );
  }

  Widget createDecoration(BuildContext context, FlexibleColumn<T> column, T data) {
    final Size fixedSize = Size(
      column.fixedWidth,
      columnController.infoRowHeightBuilder?.call(context, data) ?? columnController.infoRowHeight!,
    );
    return SizedBox.fromSize(
      size: fixedSize,
      child: decorationBuilder.call(context, column, fixedSize, data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableRowDecoration<T>(
      controller,
      columnController: columnController,
      decorationBuilder: (context, fixedHeight, data) => createRow(context, data),
    );
  }
}
