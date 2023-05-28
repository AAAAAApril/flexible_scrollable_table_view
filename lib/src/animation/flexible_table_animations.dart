import 'package:flutter/widgets.dart';

import 'animated_constraint_box.dart';

///表会用到的一些动画
abstract class AbsFlexibleTableAnimations {
  const AbsFlexibleTableAnimations();

  Widget buildConstraintAnimatedWidget(
    BoxConstraints constraints,
    Widget? child,
  );
}

class FlexibleTableAnimations extends AbsFlexibleTableAnimations {
  const FlexibleTableAnimations({
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 650),
    this.onEnd,
  });

  final Curve curve;
  final Duration duration;
  final VoidCallback? onEnd;

  @override
  Widget buildConstraintAnimatedWidget(BoxConstraints constraints, Widget? child) {
    return AnimatedConstraintBox(
      constraints,
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      child: child,
    );
  }
}
