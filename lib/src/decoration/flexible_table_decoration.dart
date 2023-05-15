import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

///表内容区域装饰器
class FlexibleTableContentDecoration<T> extends StatelessWidget {
  const FlexibleTableContentDecoration(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    required this.rowDecorationBuilder,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;

  ///行装饰器
  final TableInfoRowDecorationBuilder<T> rowDecorationBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => SizedBox(
        width: p1.maxWidth,
        child: ValueListenableBuilder<List<T>>(
          valueListenable: controller,
          builder: (context, value, child) => Column(mainAxisSize: MainAxisSize.min, children: [
            for (int index = 0; index < value.length; index++)
              TableRowDecoration<T>(
                columnConfigurations,
                dataIndex: index,
                data: value[index],
                decorationBuilder: rowDecorationBuilder,
              ),
          ]),
        ),
      ),
    );
  }
}

///表行装饰
class TableRowDecoration<T> extends StatelessWidget {
  const TableRowDecoration(
    this.columnConfigurations, {
    super.key,
    required this.dataIndex,
    required this.data,
    required this.decorationBuilder,
  });

  final FlexibleColumnConfigurations<T> columnConfigurations;
  final int dataIndex;
  final T data;

  ///行装饰器
  final TableInfoRowDecorationBuilder<T> decorationBuilder;

  @override
  Widget build(BuildContext context) {
    final double fixedHeight = columnConfigurations.fixedInfoRowHeight(context, data);
    return SizedBox(
      height: fixedHeight,
      child: decorationBuilder.call(context, fixedHeight, dataIndex, data),
    );
  }
}
