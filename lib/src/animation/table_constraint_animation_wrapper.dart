import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'flexible_table_animations.dart';

///表约束动画包装
class TableConstraintAnimationWrapper<T> extends StatelessWidget {
  const TableConstraintAnimationWrapper(
    this.controller, {
    super.key,
    this.animations,
    required this.constraints,
    required this.child,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableAnimations? animations;
  final BoxConstraints constraints;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (animations == null) {
      return ConstrainedBox(
        constraints: constraints,
        child: child,
      );
    }
    return animations!.buildConstraintAnimatedWidget(
      constraints,
      child,
    );
  }
}
