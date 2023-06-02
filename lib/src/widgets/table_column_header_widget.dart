import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/decoration/table_item_decoration_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

///列头组件
class TableColumnHeaderWidget<T> extends StatelessWidget {
  const TableColumnHeaderWidget(
    this.arguments, {
    super.key,
    this.animations,
    this.decorations,
    required this.column,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final AbsFlexibleTableAnimations<T>? animations;
  final AbsFlexibleTableDecorations<T>? decorations;

  ///列配置
  final AbsFlexibleColumn<T> column;

  @override
  Widget build(BuildContext context) {
    //行高
    final double height = arguments.rowHeight;
    Widget child = TableConstraintAnimationWrapper<T>(
      animations: animations,
      constraints: BoxConstraints.tight(
        Size(
          column.columnWidth.getColumnWidth(arguments.parentWidth),
          height,
        ),
      ),
      child: height <= 0
          ? null
          : TableHeaderItemDecorationWrapper<T>(
              arguments,
              decorations: decorations,
              column: column,
              child: column.buildHeader(arguments),
            ),
    );
    //可选列
    if (column is AbsSelectableColumn<T>) {
      child = SelectableColumnWrapper<T>(
        arguments.controller,
        selectableWidget: child,
        unSelectableBuilder: (context) {
          final AbsSelectableColumn<T> thisColumn = column as AbsSelectableColumn<T>;
          return TableConstraintAnimationWrapper<T>(
            constraints: BoxConstraints.tight(
              Size(
                thisColumn.unSelectableWidth.getColumnWidth(arguments.parentWidth),
                height,
              ),
            ),
            animations: animations,
            child: height <= 0
                ? null
                : TableHeaderItemDecorationWrapper<T>(
                    arguments,
                    decorations: decorations,
                    column: column,
                    child: thisColumn.buildUnSelectableHeader(arguments),
                  ),
          );
        },
      );
    }
    return child;
  }
}
