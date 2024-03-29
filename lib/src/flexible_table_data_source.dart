import 'package:flutter/foundation.dart';

import 'selectable/table_selectable_mixin.dart';
import 'sortable/table_sortable_mixin.dart';

///表数据源
///[T] 表数据实体
class FlexibleTableDataSource<T> extends ChangeNotifier
    with TableSortableMixin<T>, TableSelectableMixin<T>
    implements ValueListenable<List<T>> {
  FlexibleTableDataSource() : super() {
    addValueSettingCallback(_onValueSetting);
  }

  @override
  void dispose() {
    removeValueSettingCallback(_onValueSetting);
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

  void _onValueSetting(List<T> oldValue, List<T> newValue) {
    onSelectableValueChanged();
  }
}

typedef TableValueSettingCallback<T> = void Function(List<T> oldValue, List<T> newValue);
