import 'package:flutter/widgets.dart';

mixin NoOverscrollBehaviorMixin on ScrollBehavior {
  ///不使用过度滚动效果的方向
  List<AxisDirection> get disallowedDirections;

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    //不使用任何过度滚动效果
    if (disallowedDirections.contains(details.direction)) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}

///允许设置不使用过度滚动效果的滚动行为配置类
class NoOverscrollScrollBehavior extends ScrollBehavior with NoOverscrollBehaviorMixin {
  const NoOverscrollScrollBehavior({
    this.disallowedDirections = AxisDirection.values,
  }) : super();

  @override
  final List<AxisDirection> disallowedDirections;
}
