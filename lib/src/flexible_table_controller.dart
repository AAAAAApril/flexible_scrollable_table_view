import 'package:flutter/foundation.dart';

import 'scrollable/synchronized_scroll_mixin.dart';
import 'selectable/selectable_row_mixin.dart';
import 'sortable/sortable_column_mixin.dart';

///表控制器
///[T] 表数据实体
class FlexibleTableController<T> extends ChangeNotifier
    with SortableColumnMixin<T>, SelectableRowMixin<T>
    implements ValueListenable<List<T>> {
  FlexibleTableController({
    SynchronizedScrollMixin? horizontalScrollController,
  })  : _horizontalScrollController = horizontalScrollController,
        horizontalScrollController = horizontalScrollController ?? SynchronizedScrollController(),
        super(){
    addValueSettingCallback(_onValueSetting);
  }

  ///用于横向滚动区域的同步滚动控制器
  final SynchronizedScrollMixin horizontalScrollController;
  final SynchronizedScrollMixin? _horizontalScrollController;

  @override
  void dispose() {
    removeValueSettingCallback(_onValueSetting);
    if (_horizontalScrollController == null) {
      horizontalScrollController.dispose();
    }
    super.dispose();
  }

  ///原始数据
  List<T> _rawValue = <T>[];

  @override
  List<T> get selectableValue => _rawValue;

  @override
  List<T> get sortableValue => _rawValue;

  List<T> get rawValue => _rawValue;

  @override
  List<T> get value => sortedValue;

  ///设置新数据时的回调
  final List<TableValueSettingCallback<T>> _settingCallback = <TableValueSettingCallback<T>>[];

  set value(List<T> newValue) {
    if (_rawValue == newValue || (_rawValue.isEmpty && newValue.isEmpty)) {
      return;
    }
    final oldValue = _rawValue;
    _rawValue = newValue;
    for (final element in _settingCallback) {
      element.call(oldValue, newValue);
    }
    sortData();
  }

  ///添加设置数据时的回调
  void addValueSettingCallback(TableValueSettingCallback<T> callback) {
    if (!_settingCallback.contains(callback)) {
      _settingCallback.add(callback);
    }
  }

  ///移除设置数据时的回调
  void removeValueSettingCallback(TableValueSettingCallback<T> callback) {
    _settingCallback.remove(callback);
  }

  void _onValueSetting(List<T> oldValue, List<T> newValue){
    onSelectableValueChanged();
  }

}

typedef TableValueSettingCallback<T> = void Function(List<T> oldValue, List<T> newValue);
