import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/synchronized_scroll_mixin.dart';

/// Will be deprecated in few versions later.
/// Use FlexibleTableDataSource<T> instead.
class FlexibleTableController<T> extends FlexibleTableDataSource<T> {
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
}
