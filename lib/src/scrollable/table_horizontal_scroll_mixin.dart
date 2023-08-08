import 'package:flutter/widgets.dart';

///表的横向滚动功能
mixin TableHorizontalScrollMixin {
  ///创建控制器
  ScrollController createScrollController();

  ///销毁控制器
  void destroyScrollController(ScrollController controller);
}
