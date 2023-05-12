import 'package:flutter/widgets.dart';

mixin ScrollSynchronizationMixin on ChangeNotifier {
  @override
  void dispose() {
    nameRowScrollController.dispose();
    dataAreaScrollController.dispose();
    super.dispose();
  }

  ///列名行横向滚动控制器
  final ScrollController nameRowScrollController = ScrollController();

  ///数据区域横向滚动控制器
  final ScrollController dataAreaScrollController = ScrollController();

  ///开始同步
  void startSync() {
    nameRowScrollController.addListener(onNameRowScrollUpdated);
    dataAreaScrollController.addListener(onDataRowScrollUpdated);
  }

  ///停止同步
  void stopSync() {
    dataAreaScrollController.removeListener(onDataRowScrollUpdated);
    nameRowScrollController.removeListener(onNameRowScrollUpdated);
  }

  ///列名行滚动更新
  @protected
  void onNameRowScrollUpdated() {
    if (nameRowScrollController.offset != dataAreaScrollController.offset && dataAreaScrollController.hasClients) {
      dataAreaScrollController.jumpTo(nameRowScrollController.offset);
    }
  }

  ///数据区域滚动更新
  @protected
  void onDataRowScrollUpdated() {
    if (nameRowScrollController.offset != dataAreaScrollController.offset && nameRowScrollController.hasClients) {
      nameRowScrollController.jumpTo(dataAreaScrollController.offset);
    }
  }
}
