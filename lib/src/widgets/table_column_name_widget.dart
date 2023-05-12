import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/material.dart';

///列名组件
class TableColumnNameWidget<T> extends StatelessWidget {
  const TableColumnNameWidget(
    this.controller, {
    Key? key,
    required this.column,
    this.nameAlignment,
    required this.height,
  }) : super(key: key);

  final FlexibleTableController<T> controller;

  ///列配置
  final FlexibleColumn<T> column;

  ///列名组件在容器内的对齐方式
  final AlignmentGeometry? nameAlignment;

  ///行高
  final double height;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: column.fixedWidth,
      height: height,
      child: Align(
        alignment: nameAlignment ?? column.nameAlignment,
        child: column.nameBuilder.call(
          context,
          Size(column.fixedWidth, height),
        ),
      ),
    );
    final TableColumnNamePressedCallback<T>? pressedCallback = column.onColumnNamePressed;
    final Comparator<T>? comparator = column.comparator;
    if (pressedCallback != null || comparator != null) {
      child = Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (pressedCallback != null) {
              if (pressedCallback.call(context, column)) {
                return;
              }
            }
            if (comparator != null) {
              controller.sortByColumn(column);
            }
          },
          child: child,
        ),
      );
    }
    return child;
  }
}
