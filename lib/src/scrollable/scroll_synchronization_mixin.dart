import 'package:flutter/widgets.dart';

mixin ScrollSynchronizationMixin {
  void dispose() {
    headerRowScrollController.dispose();
  }

  ///列头行横向滚动控制器
  final ScrollController headerRowScrollController = ScrollController();

  ///开始同步
  void startSync() {}

  ///停止同步
  void stopSync() {}
}
