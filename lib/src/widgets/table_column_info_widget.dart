import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/decoration/table_item_decoration_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column_wrapper.dart';
import 'package:flutter/widgets.dart';

///列信息组件
class TableColumnInfoWidget<T> extends StatelessWidget {
  const TableColumnInfoWidget(
    this.controller, {
    super.key,
    required this.configurations,
    this.animations,
    this.decorations,
    required this.dataIndex,
    required this.data,
    required this.column,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAnimations<T>? animations;
  final AbsFlexibleTableDecorations<T>? decorations;

  final int dataIndex;
  final T data;

  ///列配置
  final AbsFlexibleColumn<T> column;

  ///行高
  final double height;

  @override
  Widget build(BuildContext context) {
    Widget child = TableInfoItemConstraintAnimationWrapper<T>(
      controller,
      constraints: BoxConstraints.tight(
        Size(column.fixedWidth, height),
      ),
      animations: animations,
      column: column,
      dataIndex: dataIndex,
      data: data,
      child: height <= 0
          ? null
          : TableInfoItemDecorationWrapper<T>(
              controller,
              configurations: configurations,
              decorations: decorations,
              dataIndex: dataIndex,
              data: data,
              child: column.buildInfo(controller, configurations, dataIndex, data),
            ),
    );
    //可选列
    if (column is AbsSelectableColumn<T>) {
      child = SelectableColumnWrapper<T>(
        controller,
        selectableWidget: child,
        unSelectableBuilder: (context) {
          final AbsSelectableColumn<T> thisColumn = column as AbsSelectableColumn<T>;
          return TableInfoItemConstraintAnimationWrapper<T>(
            controller,
            animations: animations,
            constraints: BoxConstraints.tight(
              Size(thisColumn.unSelectableWidth, height),
            ),
            column: column,
            dataIndex: dataIndex,
            data: data,
            child: height <= 0
                ? null
                : TableInfoItemDecorationWrapper<T>(
                    controller,
                    configurations: configurations,
                    decorations: decorations,
                    dataIndex: dataIndex,
                    data: data,
                    child: thisColumn.buildUnSelectableInfo(
                      controller,
                      configurations,
                      dataIndex,
                      data,
                    ),
                  ),
          );
        },
      );
    }
    return child;
  }
}
