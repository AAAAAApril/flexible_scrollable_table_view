import 'package:flutter/widgets.dart';

mixin ScrollSynchronizationMixin {
  void dispose() {
    headerRowScrollController.dispose();
    // contentAreaScrollController.dispose();
  }

  ///是否没有纵向滚动效果
  bool noVerticalScrollBehavior = false;

  ///是否没有横向滚动效果
  bool noHorizontalScrollBehavior = false;

  ///列头行横向滚动控制器
  final ScrollController headerRowScrollController = ScrollController();

  ///内容区域横向滚动控制器
  // final ScrollController contentAreaScrollController = ScrollController();

  ///开始同步
  void startSync() {
    headerRowScrollController.addListener(onHeaderRowScrollUpdated);
    // contentAreaScrollController.addListener(onContentAreaScrollUpdated);
  }

  ///停止同步
  void stopSync() {
    // contentAreaScrollController.removeListener(onContentAreaScrollUpdated);
    headerRowScrollController.removeListener(onHeaderRowScrollUpdated);
  }

  ///列头行滚动更新
  @protected
  void onHeaderRowScrollUpdated() {
    // if (headerRowScrollController.offset != contentAreaScrollController.offset &&
    //     contentAreaScrollController.hasClients) {
    //   contentAreaScrollController.jumpTo(headerRowScrollController.offset);
    // }
  }

  ///内容区域滚动更新
  @protected
  void onContentAreaScrollUpdated() {
    // if (headerRowScrollController.offset != contentAreaScrollController.offset &&
    //     headerRowScrollController.hasClients) {
    //   headerRowScrollController.jumpTo(contentAreaScrollController.offset);
    // }
  }
}
