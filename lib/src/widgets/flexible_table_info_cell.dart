import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/dynamic_width/dynamic_width_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column_cell_wrapper.dart';
import 'package:flutter/widgets.dart';

///列信息组件
class FlexibleTableInfoCell<T> extends StatelessWidget {
  const FlexibleTableInfoCell(
    this.arguments, {
    super.key,
    this.animations,
    required this.column,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableAnimations<T>? animations;

  ///列配置
  final AbsFlexibleColumn<T> column;

  @override
  Widget build(BuildContext context) {
    if (column is AbsDynamicWidthColumn<T, dynamic>) {
      return (column as AbsDynamicWidthColumn<T, dynamic>).buildDynamicInfoCell(arguments, animations);
    }
    Widget child = TableConstraintAnimationWrapper<T>(
      animations: animations,
      constraints: BoxConstraints.tightFor(
        width: column.columnWidth.getColumnWidth(arguments.parentWidth),
        height: arguments.rowHeight,
      ),
      child: arguments.rowHeight <= 0 ? null : column.buildInfoCell(arguments),
    );
    //可选列
    if (column is AbsSelectableColumn<T>) {
      child = SelectableColumnCellWrapper<T>(
        arguments.controller,
        selectableWidget: child,
        unSelectableBuilder: (context) {
          final AbsSelectableColumn<T> thisColumn = column as AbsSelectableColumn<T>;
          return TableConstraintAnimationWrapper<T>(
            animations: animations,
            constraints: BoxConstraints.tightFor(
              width: thisColumn.unSelectableWidth.getColumnWidth(arguments.parentWidth),
              height: arguments.rowHeight,
            ),
            child: arguments.rowHeight <= 0 ? null : thisColumn.buildUnSelectableInfoCell(arguments),
          );
        },
      );
    }
    return child;
  }
}
