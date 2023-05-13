import 'package:flexible_scrollable_table_view/src/custom/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/custom/selectable/selectable_column_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

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
    final Size fixedSize = Size(column.fixedWidth, height);
    Widget child = SizedBox.fromSize(
      size: fixedSize,
      child: Align(
        alignment: nameAlignment ?? column.nameAlignment,
        child: column.nameBuilder.call(context, fixedSize),
      ),
    );
    //可选名
    if (column is SelectableColumn<T>) {
      child = SelectableColumnWrapper<T>(
        controller,
        unSelectableBuilder: (context) {
          final SelectableColumn<T> thisColumn = column as SelectableColumn<T>;
          final Size unSelectableSize = Size(thisColumn.unSelectableWidth, height);
          return SizedBox.fromSize(
            size: unSelectableSize,
            child: Align(
              alignment: nameAlignment ?? thisColumn.unSelectableNameAlignment,
              child: thisColumn.unSelectableName?.call(context, unSelectableSize),
            ),
          );
        },
        child: child,
      );
    }
    //不可选名
    else {
      if (column.onColumnNamePressed != null || column.comparator != null) {
        child = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (column.onColumnNamePressed?.call(context, column) == true) {
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
