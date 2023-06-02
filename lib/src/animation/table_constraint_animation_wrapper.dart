import 'package:flutter/widgets.dart';

import 'flexible_table_animations.dart';

///表约束动画包装
class TableConstraintAnimationWrapper<T> extends StatelessWidget {
  const TableConstraintAnimationWrapper({
    super.key,
    this.animations,
    required this.constraints,
    this.child,
  });

  final AbsFlexibleTableAnimations<T>? animations;
  final BoxConstraints constraints;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return animations?.constraintAnimationBuilder?.call(constraints, child) ??
        ConstrainedBox(constraints: constraints, child: child);
  }
}
