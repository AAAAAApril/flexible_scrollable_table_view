import 'package:flexible_scrollable_table_view/src/custom/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/custom/selectable_column_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

///列信息组件
class TableColumnInfoWidget<T> extends StatelessWidget {
  const TableColumnInfoWidget(
    this.controller, {
    Key? key,
    required this.data,
    required this.column,
    required this.height,
    required this.infoAlignment,
  }) : super(key: key);

  final FlexibleTableController<T> controller;

  final T data;

  ///列配置
  final FlexibleColumn<T> column;

  ///列信息组件在容器内的对齐方式
  final AlignmentGeometry? infoAlignment;

  ///行高
  final double height;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: column.fixedWidth,
      height: height,
      child: Align(
        alignment: infoAlignment ?? column.infoAlignment,
        child: column.infoBuilder.call(
          context,
          Size(column.fixedWidth, height),
          data,
        ),
      ),
    );
    if (column is SelectableColumn<T>) {
      return SelectableColumnWrapper<T>(
        controller,
        child: child,
      );
    }
    final TableColumnInfoPressedCallback<T>? pressedCallback = column.onColumnInfoPressed;
    if (pressedCallback != null) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          pressedCallback.call(context, column, data);
        },
        child: child,
      );
    }
    return child;
  }
}
