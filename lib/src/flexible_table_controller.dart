import 'package:flexible_scrollable_table_view/src/scrollable/synchronized_scroll_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'selectable/selectable_row_mixin.dart';
import 'sortable/sortable_column_mixin.dart';

abstract class FlexibleTableValueListenable<T> extends ValueListenable<T> {
  const FlexibleTableValueListenable() : super();

  ///原始数据
  T get tableValue;
}

///表控制器
///[T] 表数据实体
class FlexibleTableController<T> extends ChangeNotifier
    with SortableColumnMixin<T>, SelectableRowMixin<T>
    implements FlexibleTableValueListenable<List<T>> {
  FlexibleTableController() : super();

  ///用于横向滚动区域的同步滚动控制器
  final ScrollController horizontalScrollController = SynchronizedScrollController();

  @override
  void dispose() {
    horizontalScrollController.dispose();
    super.dispose();
  }

  ///原始数据
  List<T> _rawValue = <T>[];

  @override
  List<T> get selectableValue => _rawValue;

  @override
  List<T> get sortableValue => _rawValue;

  @override
  List<T> get tableValue => _rawValue;

  @override
  List<T> get value => sortedValue;

  set value(List<T> newValue) {
    if (_rawValue == newValue || (_rawValue.isEmpty && newValue.isEmpty)) {
      return;
    }
    _rawValue = newValue;
    onSelectableValueChanged();
    sortData();
  }
}
