import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column_wrapper.dart';
import 'package:flutter/widgets.dart';

///列头组件
class TableColumnHeaderWidget<T> extends StatelessWidget {
  const TableColumnHeaderWidget(
    this.controller, {
    super.key,
    required this.column,
    required this.height,
  });

  final FlexibleTableController<T> controller;

  ///列配置
  final FlexibleColumn<T> column;

  ///行高
  final double height;

  @override
  Widget build(BuildContext context) {
    final Size fixedSize = Size(column.fixedWidth, height);
    Widget child = SizedBox.fromSize(
      size: fixedSize,
      child: column.buildHeader(controller, context, fixedSize),
    );
    //可选列
    if (column is SelectableColumn<T>) {
      child = SelectableColumnWrapper<T>(
        controller,
        unSelectableBuilder: (context) {
          final SelectableColumn<T> thisColumn = column as SelectableColumn<T>;
          final Size unSelectableSize = Size(thisColumn.unSelectableWidth, height);
          return SizedBox.fromSize(
            size: unSelectableSize,
            child: thisColumn.buildUnSelectableHeader(controller, context, unSelectableSize),
          );
        },
        child: child,
      );
    }
    return child;
  }
}
