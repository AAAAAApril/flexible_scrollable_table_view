import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

import 'animated_constraint_box.dart';

typedef TableConstraintAnimationBuilder<T> = Widget Function(
  BoxConstraints constraints,
  Widget? child,
);

typedef TableHeaderItemConstraintAnimationBuilder<T> = Widget Function(
  AbsFlexibleColumn<T> column,
  BoxConstraints constraints,
  Widget? child,
);

typedef TableInfoItemConstraintAnimationBuilder<T> = Widget Function(
  AbsFlexibleColumn<T> column,
  int dataIndex,
  T data,
  BoxConstraints constraints,
  Widget? child,
);

typedef TableInfoRowConstraintAnimationBuilder<T> = Widget Function(
  int dataIndex,
  T data,
  BoxConstraints constraints,
  Widget? child,
);

///表会用到的一些动画
abstract class AbsFlexibleTableAnimations<T> {
  const AbsFlexibleTableAnimations();

  ///约束变更动画
  TableConstraintAnimationBuilder<T>? get constraintAnimationBuilder => null;

  ///表头项约束变更动画
  TableHeaderItemConstraintAnimationBuilder<T>? get headerItemConstraintAnimationBuilder =>
      constraintAnimationBuilder == null
          ? null
          : (column, constraints, child) => constraintAnimationBuilder!.call(constraints, child);

  ///表头行约束变更动画
  TableConstraintAnimationBuilder<T>? get headerRowConstraintAnimationBuilder => constraintAnimationBuilder;

  ///表信息项约束变更动画
  TableInfoItemConstraintAnimationBuilder<T>? get infoItemConstraintAnimationBuilder =>
      constraintAnimationBuilder == null
          ? null
          : (column, dataIndex, data, constraints, child) => constraintAnimationBuilder!.call(constraints, child);

  ///表信息行约束变更动画
  TableInfoRowConstraintAnimationBuilder<T>? get infoRowConstraintAnimationBuilder => constraintAnimationBuilder == null
      ? null
      : (dataIndex, data, constraints, child) => constraintAnimationBuilder!.call(constraints, child);
}

class FlexibleTableAnimations<T> extends AbsFlexibleTableAnimations<T> {
  const FlexibleTableAnimations({
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 650),
    this.onEnd,
  });

  final Curve curve;
  final Duration duration;
  final VoidCallback? onEnd;

  @override
  TableConstraintAnimationBuilder<T> get constraintAnimationBuilder => (constraints, child) => AnimatedConstraintBox(
        constraints,
        duration: duration,
        curve: curve,
        onEnd: onEnd,
        child: child,
      );
}
