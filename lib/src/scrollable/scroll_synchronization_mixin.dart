import 'package:flutter/widgets.dart';

mixin ScrollSynchronizationMixin {
  ///横向滚动控制器缓存
  final Map<ScrollController, VoidCallback> _scrollControllerCache = <ScrollController, VoidCallback>{};

  ///创建横向滚动控制器
  ScrollController createHorizontalScrollController() {
    double offset = 0;
    if (_scrollControllerCache.isNotEmpty) {
      try {
        offset = _scrollControllerCache.keys.first.offset;
      } catch (_) {
        //ignore
      }
    }
    final controller = ScrollController(initialScrollOffset: offset);
    void listener() {
      _onHorizontalScrollChanged(controller);
    }

    _scrollControllerCache[controller] = listener;
    controller.addListener(listener);
    return controller;
  }

  ///释放横向滚动控制器
  void releaseHorizontalScrollController(ScrollController controller) {
    controller.removeListener(_scrollControllerCache[controller]!);
    _scrollControllerCache.remove(controller);
    controller.dispose();
  }

  void _onHorizontalScrollChanged(ScrollController controller) {
    for (var element in List<ScrollController>.of(_scrollControllerCache.keys)) {
      try {
        if (element != controller &&
            element.hasClients &&
            controller.hasClients &&
            element.offset != controller.offset) {
          element.jumpTo(controller.offset);
        }
      } catch (_) {
        //ignore
      }
    }
  }
}
