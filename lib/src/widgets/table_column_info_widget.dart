import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
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
    required this.dataIndex,
    required this.data,
    required this.column,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAnimations? animations;

  final int dataIndex;
  final T data;

  ///列配置
  final AbsFlexibleColumn<T> column;

  ///行高
  final double height;

  @override
  Widget build(BuildContext context) {
    final BoxConstraints constraints = BoxConstraints.tight(
      Size(column.fixedWidth, height),
    );
    Widget? child = height <= 0 ? null : column.buildInfo(controller, configurations, dataIndex, data);
    if (animations != null) {
      child = animations!.buildConstraintAnimatedWidget(
        constraints,
        child,
      );
    } else {
      child = ConstrainedBox(
        constraints: constraints,
        child: child,
      );
    }
    //可选列
    if (column is AbsSelectableColumn<T>) {
      child = SelectableColumnWrapper<T>(
        controller,
        unSelectableBuilder: (context) {
          final AbsSelectableColumn<T> thisColumn = column as AbsSelectableColumn<T>;
          Widget? child = height <= 0
              ? null
              : thisColumn.buildUnSelectableInfo(
                  controller,
                  configurations,
                  dataIndex,
                  data,
                );
          final BoxConstraints constraints = BoxConstraints.tight(
            Size(thisColumn.unSelectableWidth, height),
          );
          if (animations != null) {
            return animations!.buildConstraintAnimatedWidget(
              constraints,
              child,
            );
          }
          return ConstrainedBox(
            constraints: constraints,
            child: child,
          );
        },
        child: child,
      );
    }
    return child;
  }
}
