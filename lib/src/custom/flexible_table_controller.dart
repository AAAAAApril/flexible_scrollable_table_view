import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/synchronized_scroll_mixin.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flutter/widgets.dart';

/// Will be deprecated in few versions later.
@Deprecated('Use FlexibleTableDataSource<T> instead.')
class FlexibleTableController<T> extends FlexibleTableDataSource<T> with TableHorizontalScrollMixin {
  FlexibleTableController({
    SynchronizedScrollMixin? horizontalScrollController,
  })  : _horizontalScrollController = horizontalScrollController,
        horizontalScrollController = horizontalScrollController ?? SynchronizedScrollController(),
        super();

  ///用于横向滚动区域的同步滚动控制器
  final SynchronizedScrollMixin horizontalScrollController;
  final SynchronizedScrollMixin? _horizontalScrollController;

  @override
  void dispose() {
    super.dispose();
    if (_horizontalScrollController == null) {
      horizontalScrollController.dispose();
    }
  }

  @override
  ScrollController createScrollController() => horizontalScrollController;

  @override
  void destroyScrollController(ScrollController controller) {
    //ignore
  }
}
