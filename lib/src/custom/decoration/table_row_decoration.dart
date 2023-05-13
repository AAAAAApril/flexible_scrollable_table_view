import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

///表行装饰
class TableRowDecoration<T> extends StatelessWidget {
  const TableRowDecoration(
    this.controller, {
    super.key,
    required this.columnController,
    required this.decorationBuilder,
  });

  ///控制器
  final FlexibleTableController<T> controller;

  ///列配置
  final FlexibleColumnController<T> columnController;

  ///表行装饰
  final TableRowDecorationBuilder<T> decorationBuilder;

  Widget createDecoration(BuildContext context, T data) {
    final double fixedHeight =
        columnController.infoRowHeightBuilder?.call(context, data) ?? columnController.infoRowHeight!;
    return SizedBox(
      height: fixedHeight,
      child: decorationBuilder.call(context, fixedHeight, data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: value.map<Widget>((data) => createDecoration(context, data)).toList(growable: false),
      ),
    );
  }
}
