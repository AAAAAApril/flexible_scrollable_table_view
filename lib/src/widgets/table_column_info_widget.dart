import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column_wrapper.dart';
import 'package:flutter/widgets.dart';

///列信息组件
class TableColumnInfoWidget<T> extends StatelessWidget {
  const TableColumnInfoWidget(
    this.arguments, {
    super.key,
    this.animations,
    this.decorations,
    required this.column,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableAnimations<T>? animations;
  final AbsFlexibleTableDecorations<T>? decorations;

  ///列配置
  final AbsFlexibleColumn<T> column;

  @override
  Widget build(BuildContext context) {
    Widget child = TableConstraintAnimationWrapper<T>(
      constraints: BoxConstraints.tight(
        Size(
          column.columnWidth.getColumnWidth(arguments.parentWidth),
          arguments.rowHeight,
        ),
      ),
      animations: animations,
      child: arguments.rowHeight <= 0 ? null : column.buildInfo(arguments),
    );
    //可选列
    if (column is AbsSelectableColumn<T>) {
      child = SelectableColumnWrapper<T>(
        arguments.controller,
        selectableWidget: child,
        unSelectableBuilder: (context) {
          final AbsSelectableColumn<T> thisColumn = column as AbsSelectableColumn<T>;
          return TableConstraintAnimationWrapper<T>(
            animations: animations,
            constraints: BoxConstraints.tight(
              Size(
                thisColumn.unSelectableWidth.getColumnWidth(arguments.parentWidth),
                arguments.rowHeight,
              ),
            ),
            child: arguments.rowHeight <= 0 ? null : thisColumn.buildUnSelectableInfo(arguments),
          );
        },
      );
    }
    return child;
  }
}
