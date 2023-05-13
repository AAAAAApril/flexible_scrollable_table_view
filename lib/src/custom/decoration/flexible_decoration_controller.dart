import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///装饰控制器
///本类主要处理装饰跟随表信息同步滚动的问题，由于装饰器的滚动控制器没有添加滚动监听，所以不支持反向控制表的滚动。
///Tips：当装饰器需要精确控制到每一个信息节点的时候，可以使用本类。
class FlexibleDecorationController<T> {
  FlexibleDecorationController(this.controller) {
    controller.headerRowScrollController.addListener(_onTableHeaderScrollChanged);
  }

  void dispose() {
    controller.headerRowScrollController.removeListener(_onTableHeaderScrollChanged);
    headerScrollController.dispose();
    contentScrollController.dispose();
  }

  ///表控制器
  final FlexibleTableController<T> controller;

  ///装饰器表头区域滚动控制器
  final ScrollController headerScrollController = ScrollController();

  ///装饰器表内容区域滚动控制器
  final ScrollController contentScrollController = ScrollController();

  ///表头滚动变化
  void _onTableHeaderScrollChanged() {
    final double offset = controller.headerRowScrollController.offset;
    if (headerScrollController.hasClients && offset != headerScrollController.offset) {
      headerScrollController.jumpTo(offset);
    }
    if (contentScrollController.hasClients && offset != contentScrollController.offset) {
      contentScrollController.jumpTo(offset);
    }
  }
}
