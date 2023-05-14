import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

///表内容区域装饰器
class FlexibleTableContentDecoration<T> extends StatelessWidget {
  const FlexibleTableContentDecoration(
    this.controller, {
    super.key,
    required this.columnController,
    required this.rowDecorationBuilder,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnController<T> columnController;

  ///行装饰器
  final TableInfoRowDecorationBuilder<T> rowDecorationBuilder;

  @override
  Widget build(BuildContext context) {
    final Set<FlexibleColumn<T>> columns = Set.of(columnController.pinnedColumns)
      ..addAll(columnController.scrollableColumns);
    return SizedBox(
      width: columns.fold<double>(0, (previousValue, element) => previousValue + element.fixedWidth),
      child: ValueListenableBuilder<List<T>>(
        valueListenable: controller,
        builder: (context, value, child) => Column(mainAxisSize: MainAxisSize.min, children: [
          for (int index = 0; index < value.length; index++)
            TableRowDecoration<T>(
              columnController,
              dataIndex: index,
              data: value[index],
              decorationBuilder: rowDecorationBuilder,
            ),
        ]),
      ),
    );
  }
}

///表行装饰
class TableRowDecoration<T> extends StatelessWidget {
  const TableRowDecoration(
    this.columnController, {
    super.key,
    required this.dataIndex,
    required this.data,
    required this.decorationBuilder,
  });

  final FlexibleColumnController<T> columnController;
  final int dataIndex;
  final T data;

  ///行装饰器
  final TableInfoRowDecorationBuilder<T> decorationBuilder;

  @override
  Widget build(BuildContext context) {
    final double fixedHeight =
        columnController.infoRowHeightBuilder?.call(context, data) ?? columnController.infoRowHeight!;
    return SizedBox(
      height: fixedHeight,
      child: decorationBuilder.call(context, fixedHeight, dataIndex, data),
    );
  }
}
