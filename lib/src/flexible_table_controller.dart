import 'package:flexible_scrollable_table_view/src/scrollable/scroll_synchronization_mixin.dart';
import 'package:flutter/foundation.dart';

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
    with SortableColumnMixin<T>, SelectableRowMixin<T>, ScrollSynchronizationMixin
    implements FlexibleTableValueListenable<List<T>> {
  FlexibleTableController() : super();

  @override
  void dispose() {
    _loadedDataOnce.dispose();
    super.dispose();
  }

  ///原始数据
  List<T> _rawValue = <T>[];

  ///是否加载过一次数据了（只要有任何一次数据不为空，则 _loadedDataOnce.value = true ）
  final ValueNotifier<bool> _loadedDataOnce = ValueNotifier<bool>(false);

  ValueListenable<bool> get loadedDataOnce => _loadedDataOnce;

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
    if (newValue.isNotEmpty) {
      _loadedDataOnce.value = true;
    }
    onSelectableValueChanged();
    sortData();
  }

  ///重置数据是否已经加载过一次的状态
  void resetDataLoadedOnce() {
    _loadedDataOnce.value = false;
  }
}
