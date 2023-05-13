import 'package:flutter/widgets.dart';

mixin ScrollSynchronizationMixin on ChangeNotifier {
  @override
  void dispose() {
    headerRowScrollController.dispose();
    contentAreaScrollController.dispose();
    super.dispose();
  }

  ///列头行横向滚动控制器
  final ScrollController headerRowScrollController = ScrollController();

  ///内容区域横向滚动控制器
  final ScrollController contentAreaScrollController = ScrollController();

  ///开始同步
  void startSync() {
    headerRowScrollController.addListener(onHeaderRowScrollUpdated);
    contentAreaScrollController.addListener(onContentAreaScrollUpdated);
  }

  ///停止同步
  void stopSync() {
    contentAreaScrollController.removeListener(onContentAreaScrollUpdated);
    headerRowScrollController.removeListener(onHeaderRowScrollUpdated);
  }

  ///列头行滚动更新
  @protected
  void onHeaderRowScrollUpdated() {
    if (headerRowScrollController.offset != contentAreaScrollController.offset &&
        contentAreaScrollController.hasClients) {
      contentAreaScrollController.jumpTo(headerRowScrollController.offset);
    }
  }

  ///内容区域滚动更新
  @protected
  void onContentAreaScrollUpdated() {
    if (headerRowScrollController.offset != contentAreaScrollController.offset &&
        headerRowScrollController.hasClients) {
      headerRowScrollController.jumpTo(contentAreaScrollController.offset);
    }
  }
}
