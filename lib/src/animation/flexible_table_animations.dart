import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

import 'animated_constraint_box.dart';

///表会用到的一些动画
abstract class AbsFlexibleTableAnimations<T> {
  const AbsFlexibleTableAnimations();

  ///表头行约束变更动画组件
  Widget buildTableHeaderRowConstraintAnimationWidget(
    TableHeaderRowBuildArguments<T> arguments, {
    required BoxConstraints constraints,
    required Widget rowWidget,
  });

  ///表信息行约束变更动画组件
  Widget buildTableInfoRowConstraintAnimationWidget(
    TableInfoRowBuildArguments<T> arguments, {
    required BoxConstraints constraints,
    required Widget rowWidget,
  });

  ///表头项约束变更动画组件
  Widget buildTableHeaderCellConstraintAnimationWidget(
    TableHeaderRowBuildArguments<T> arguments,
    AbsFlexibleColumn<T> column, {
    required BoxConstraints constraints,
    required Widget cellWidget,
  });

  ///表信息项约束变更动画组件
  Widget buildTableInfoCellConstraintAnimationWidget(
    TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleColumn<T> column, {
    required BoxConstraints constraints,
    required Widget cellWidget,
  });
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
  Widget buildTableHeaderRowConstraintAnimationWidget(
    TableHeaderRowBuildArguments<T> arguments, {
    required BoxConstraints constraints,
    required Widget rowWidget,
  }) {
    return AnimatedConstraintBox(
      constraints,
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      child: rowWidget,
    );
  }

  @override
  Widget buildTableInfoRowConstraintAnimationWidget(
    TableInfoRowBuildArguments<T> arguments, {
    required BoxConstraints constraints,
    required Widget rowWidget,
  }) {
    return AnimatedConstraintBox(
      constraints,
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      child: rowWidget,
    );
  }

  @override
  Widget buildTableHeaderCellConstraintAnimationWidget(
    TableHeaderRowBuildArguments<T> arguments,
    AbsFlexibleColumn<T> column, {
    required BoxConstraints constraints,
    required Widget cellWidget,
  }) {
    return AnimatedConstraintBox(
      constraints,
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      child: cellWidget,
    );
  }

  @override
  Widget buildTableInfoCellConstraintAnimationWidget(
    TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleColumn<T> column, {
    required BoxConstraints constraints,
    required Widget cellWidget,
  }) {
    return AnimatedConstraintBox(
      constraints,
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      child: cellWidget,
    );
  }
}
