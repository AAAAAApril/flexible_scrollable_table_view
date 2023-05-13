import 'package:flexible_scrollable_table_view/src/custom/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/custom/selectable/selectable_column_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///列头组件
class TableColumnHeaderWidget<T> extends StatelessWidget {
  const TableColumnHeaderWidget(
    this.controller, {
    Key? key,
    required this.column,
    required this.height,
  }) : super(key: key);

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
      child: column.headerBuilder.call(context, fixedSize),
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
            child: thisColumn.unSelectableHeader?.call(context, unSelectableSize),
          );
        },
        child: child,
      );
    }
    //不可选列
    else {
      if (column.onColumnHeaderPressed != null || column.comparator != null) {
        child = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (column.onColumnHeaderPressed?.call(context, column) == true) {
              return;
            }
            controller.sortByColumn(column);
          },
          child: child,
        );
      }
    }
    return child;
  }
}
