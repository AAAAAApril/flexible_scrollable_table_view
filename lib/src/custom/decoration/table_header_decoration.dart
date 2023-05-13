import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

///表头区域装饰
class TableHeaderDecoration<T> extends StatelessWidget {
  const TableHeaderDecoration(
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

  ///表头装饰
  final TableHeaderDecorationBuilder<T> decorationBuilder;

  Widget createDecoration(BuildContext context, FlexibleColumn<T> column) {
    final Size fixedSize = Size(column.fixedWidth, columnController.headerRowHeight);
    return SizedBox.fromSize(
      size: fixedSize,
      child: decorationBuilder.call(context, column, fixedSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns.map<Widget>((e) => createDecoration(context, e)).toList(growable: false),
    );
  }
}
