import 'package:flexible_scrollable_table_view/src/custom/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/custom/selectable/selectable_column_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///列信息组件
class TableColumnInfoWidget<T> extends StatelessWidget {
  const TableColumnInfoWidget(
    this.controller, {
    super.key,
    required this.dataIndex,
    required this.data,
    required this.column,
    required this.height,
  });

  final FlexibleTableController<T> controller;

  final int dataIndex;
  final T data;

  ///列配置
  final FlexibleColumn<T> column;

  ///行高
  final double height;

  @override
  Widget build(BuildContext context) {
    final Size fixedSize = Size(column.fixedWidth, height);
    Widget child = SizedBox.fromSize(
      size: fixedSize,
      child: column.infoBuilder.call(context, column, fixedSize, dataIndex, data),
    );
    //可选信息
    if (column is SelectableColumn<T>) {
      child = SelectableColumnWrapper<T>(
        controller,
        unSelectableBuilder: (context) {
          final SelectableColumn<T> thisColumn = column as SelectableColumn<T>;
          final Size unSelectableSize = Size(thisColumn.unSelectableWidth, height);
          return SizedBox.fromSize(
            size: unSelectableSize,
            child: thisColumn.unSelectableInfo?.call(context, column, unSelectableSize, dataIndex, data),
          );
        },
        child: child,
      );
    }
    //不可选信息
    else {
      if (column.onColumnInfoPressed != null) {
        child = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            column.onColumnInfoPressed?.call(context, column, data);
          },
          child: child,
        );
      }
    }
    return child;
  }
}
