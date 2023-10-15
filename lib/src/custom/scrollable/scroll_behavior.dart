import 'package:flutter/material.dart';

mixin NoOverscrollBehaviorMixin on ScrollBehavior {
  ///不使用过度滚动效果的方向
  List<AxisDirection> get disallowedDirections;

  ///是否需要 Scrollbar
  bool get needScrollbar;

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    if (!needScrollbar) {
      return child;
    }
    return super.buildScrollbar(context, child, details);
  }

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    //不使用任何过度滚动效果
    if (disallowedDirections.contains(details.direction)) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

///允许设置不使用过度滚动效果的滚动行为配置类
class NoOverscrollScrollBehavior extends MaterialScrollBehavior with NoOverscrollBehaviorMixin {
  const NoOverscrollScrollBehavior({
    this.disallowedDirections = AxisDirection.values,
    this.needScrollbar = false,
  }) : super();

  @override
  final List<AxisDirection> disallowedDirections;

  @override
  final bool needScrollbar;
}
