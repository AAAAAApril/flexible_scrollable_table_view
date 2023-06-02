import 'package:flutter/widgets.dart';

import 'animated_constraint_box.dart';

typedef TableConstraintAnimationBuilder<T> = Widget Function(
  //约束值
  BoxConstraints constraints,
  //被约束的组件
  Widget? child,
);

///表会用到的一些动画
abstract class AbsFlexibleTableAnimations<T> {
  const AbsFlexibleTableAnimations();

  ///约束变更动画
  TableConstraintAnimationBuilder<T>? get constraintAnimationBuilder => null;
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
