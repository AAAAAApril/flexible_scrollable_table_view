import 'package:flutter/widgets.dart';

class NoOverscrollScrollBehavior extends ScrollBehavior {
  const NoOverscrollScrollBehavior() : super();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    //不使用任何过度滚动效果
    return child;
  }
}
