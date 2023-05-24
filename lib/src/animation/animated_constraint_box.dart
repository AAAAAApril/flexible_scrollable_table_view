import 'package:flutter/widgets.dart';

///更改约束时会做动画
class AnimatedConstraintBox extends ImplicitlyAnimatedWidget {
  const AnimatedConstraintBox(
    this.constraints, {
    required this.child,
    super.key,
    required super.duration,
    super.curve,
    super.onEnd,
  });

  final BoxConstraints constraints;
  final Widget? child;

  @override
  AnimatedWidgetBaseState<AnimatedConstraintBox> createState() => _AnimatedConstraintBoxState();
}

class _AnimatedConstraintBoxState extends AnimatedWidgetBaseState<AnimatedConstraintBox> {
  BoxConstraintsTween? _constraints;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _constraints = visitor(
      _constraints,
      widget.constraints,
      (dynamic value) => BoxConstraintsTween(begin: value as BoxConstraints),
    ) as BoxConstraintsTween;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: _constraints!.evaluate(animation),
      child: widget.child,
    );
  }
}
