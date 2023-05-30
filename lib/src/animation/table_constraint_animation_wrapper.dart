import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'flexible_table_animations.dart';

///表头项约束动画包装
class TableHeaderItemConstraintAnimationWrapper<T> extends StatelessWidget {
  const TableHeaderItemConstraintAnimationWrapper(
    this.controller, {
    super.key,
    this.animations,
    required this.constraints,
    required this.column,
    required this.child,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableAnimations<T>? animations;
  final BoxConstraints constraints;
  final AbsFlexibleColumn<T> column;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      animations?.headerItemConstraintAnimationBuilder?.call(column, constraints, child) ??
      ConstrainedBox(
        constraints: constraints,
        child: child,
      );
}

///表头行约束动画包装
class TableHeaderRowConstraintAnimationWrapper<T> extends StatelessWidget {
  const TableHeaderRowConstraintAnimationWrapper(
    this.controller, {
    super.key,
    this.animations,
    required this.constraints,
    required this.child,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableAnimations<T>? animations;
  final BoxConstraints constraints;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      animations?.headerRowConstraintAnimationBuilder?.call(constraints, child) ??
      ConstrainedBox(
        constraints: constraints,
        child: child,
      );
}

///表信息项约束动画包装
class TableInfoItemConstraintAnimationWrapper<T> extends StatelessWidget {
  const TableInfoItemConstraintAnimationWrapper(
    this.controller, {
    super.key,
    this.animations,
    required this.constraints,
    required this.column,
    required this.dataIndex,
    required this.data,
    required this.child,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableAnimations<T>? animations;
  final BoxConstraints constraints;
  final AbsFlexibleColumn<T> column;
  final int dataIndex;
  final T data;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      animations?.infoItemConstraintAnimationBuilder?.call(column, dataIndex, data, constraints, child) ??
      ConstrainedBox(
        constraints: constraints,
        child: child,
      );
}

///表信息行约束动画包装
class TableInfoRowConstraintAnimationWrapper<T> extends StatelessWidget {
  const TableInfoRowConstraintAnimationWrapper(
    this.controller, {
    super.key,
    this.animations,
    required this.constraints,
    required this.dataIndex,
    required this.data,
    required this.child,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableAnimations<T>? animations;
  final BoxConstraints constraints;
  final int dataIndex;
  final T data;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      animations?.infoRowConstraintAnimationBuilder?.call(dataIndex, data, constraints, child) ??
      ConstrainedBox(
        constraints: constraints,
        child: child,
      );
}
